import { grip } from '@nesterow/grip/mod'
import { taskIndex, type ExecContext } from './task'
import { WorkerContext } from './worker.context'
import type { CmdCtx, WorkerProvider } from './worker.provider'
import { workflowIndex } from './workflow'

type WorkerOptions = {
  id: string
  name?: string
  provider: WorkerProvider
}



export class Worker {
  id: string
  name: string
  provider: WorkerProvider
  isInitialized: boolean = false

  constructor(options: WorkerOptions) {
    const { id, name, provider } = options
    this.id = id;
    this.name = name ?? '';
    this.provider = provider;
    (async () => {
      await this.useProvider()
      this.isInitialized = true
    })();
  }

  private async useProvider() {
    const { provider } = this
    await provider.pushWorkerIndex({
      taskIndex,
      workflowIndex,
    })
    provider.onCommand(async (ctx: CmdCtx) => {
      switch (ctx.target) {
        case 'task':
          await this.execTask(ctx.name, ctx)
          break
        case 'workflow':
          await this.execWorkflow(ctx.name, ctx)
          break
        default:
          break
      }
    })
  }

  async waitInit() {
    if (!this.isInitialized) {
      await (await new Promise((resolve) => {
        setTimeout(() => resolve(this.waitInit()))
      }))
    }
  }

  async execTask(name: string, cmdCtx: CmdCtx) {
    await this.waitInit()

    const Task = taskIndex.get(name)
    if (!Task) {
      throw new Error(`task not found: ${name}`)
    }
    const { provider } = this
    const instance = new Task()
    const ctx = new WorkerContext(provider, Task, cmdCtx)
    const result = await grip(instance.execute({
      params: cmdCtx.params,
      goto: ctx.goto.bind(ctx),
      resolve: ctx.resolve.bind(ctx)
    }))

    if (result.of(Error)) {
      await provider.report({
        execId: cmdCtx.execId,
        status: 'error',
        error: result.status.cause
      })
    }

    if(result.ok()) {
      await provider.report({
        execId: cmdCtx.execId,
        status: 'done'
      })
    }

  }

  async execWorkflow(name: string, ctx: CmdCtx) {}
  async getWorkflowStatus(name: string) {}
  async getTaskStatus(name: string) {}
}
