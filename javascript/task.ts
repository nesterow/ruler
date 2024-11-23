
export interface ITask {
  new(...args: any[]): ITaskInstance
  options: Options
  as(options: Options): ITask
}

export interface ITaskInstance {
  execute(ctx: ExecContext): Promise<any>
  rollback(ctx: ExecContext): Promise<any>
}

export interface ExecContext {
  params: any,
  goto: (task: string) => (params: unknown) => Promise<void>,
  resolve: (value: unknown) => Promise<void>,
}


export interface Options {
  name: string
  next?: string[]
  transitions?: string[]
  retry?: any
  schedule?: any
}

export const taskIndex = new Map<string, ITask>()

export function TaskOptions(options: Options) {
  return function (target: any): any {
    class Task extends target {
      static origin = target
      static options = options
      static as(options: Partial<Options>) {
        return TaskOptions({ ...this.options, ...options })(target)
      }
    }
    if (taskIndex.has(options.name)) {
      throw new Error(`task name must be unique (${options.name})`)
    }
    taskIndex.set(options.name, Task)
    return Task as ITask
  }
}


export class Task {
  static origin = Task
  static options: Options = { name: '' }
  static as(options: Options) {
    return class extends Task {
      static origin = this
      static {
        this.options = options
      }
    } as any as ITask
  }
  async execute(ctx: ExecContext) {
    throw new Error('not implemented')
  }
  async rollback(ctx: ExecContext) {
    throw new Error('not implemented')
  }
}


