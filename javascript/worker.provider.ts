import type { ITask } from "./task"
import type { Workflow } from "./workflow"

export type CmdCtx = {
  execId: string
  target: string
  name: string
  params: any
}

export interface WorkerProvider {
  goto(task: string, params: any): Promise<void>
  resolve(data: any): Promise<void>
  report(data: any): Promise<void>
  pushWorkerIndex(opts: {
    taskIndex: Map<string, ITask>,
    workflowIndex: Map<string, Workflow>
  }): Promise<any>
  pushWorkState(state: any): Promise<any>
  log(logs: any): Promise<any>
  onCommand(callback: (command: any) => Promise<void>): void
}
