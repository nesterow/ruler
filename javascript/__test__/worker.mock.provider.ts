import { randomUUIDv7 } from "bun";
import type { WorkerProvider } from "../worker.provider";

const execTaskCommand = (name: string) => ({
  execId: randomUUIDv7(),
  target: 'task',
  name,
  params: {
    time: Date.now(),
    data: randomUUIDv7()
  }
})

let FIFTH_IS_ERROR = 0
function throwError() {
  if (FIFTH_IS_ERROR++ % 5 === 0) {
    throw new Error('error')
  }
}

export class WorkerMockProvider implements WorkerProvider {

  private callback: (command: any) => Promise<void> = (mock: any) => Promise.resolve();

  constructor() {
    setTimeout(() => {
      this.callback(execTaskCommand('stand_up'))
    })
  }

  async goto(task: string, params: any): Promise<void> {
    throwError()
    this.callback(execTaskCommand(task))
    return Promise.resolve()
  }

  async resolve(data: any) {
    throwError()
    return Promise.resolve()
  }

  async pushWorkerIndex(): Promise<any> {
    return Promise.resolve();
  }

  async pushWorkState(state: any): Promise<any> {
    return Promise.resolve();
  }

  async log(logs: any): Promise<any> {
    return Promise.resolve();
  }

  onCommand(callback: (command: unknown) => Promise<void>): void {
    this.callback = callback;
  }
}
