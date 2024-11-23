import { grip } from '@nesterow/grip/mod';
import type { ExecContext, ITask } from './task';
import type { CmdCtx, WorkerProvider } from './worker.provider';

export class WorkerContext implements ExecContext {
  params: unknown;

  constructor(
    private provider: WorkerProvider,
    private target: ITask,
    private ctx: CmdCtx
  ) {
    this.params = this.ctx.params
  }

  goto(task: string) {
    const wrap = async (params: unknown) => {
      const result = await grip(
        this.provider.goto(task, params)
      )
      if (result.of(Error)) {
        console.warn(`provider error, retrying in ${100}ms`, task, params)
        setTimeout(() => wrap(params), 100)
      }
    }
    return wrap
  }

  resolve(params: unknown) {
    return this.provider.log({})
  }
}
