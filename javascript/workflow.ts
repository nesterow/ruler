import { Task, type ITask, type Options } from "./task"

type TaskType = ITask | Workflow

class Node {
  prev: Node | null = null
  next: Node | null = null
  input: TaskType[] | null = null
  output: TaskType[] | null = null
}

export const workflowIndex = new Map<string, Workflow>()

export class Workflow {
  state = 1
  tasks: { [id: string]: ITask | Workflow } = {}

  #first: Node | null = null
  #last: Node | null = null

  constructor(public options: Options) {
    if (workflowIndex.has(options.name)) {
      throw new Error('workflow name must be unique')
    }
    workflowIndex.set(options.name, this)
  }

  use(...tasks: (ITask| Workflow)[]) {
    const node = new Node()

    if (!this.#first) {
      this.#first = node
    }

    if (this.#last) this.#last.next = node

    node.input = this.#last?.output ?? null
    node.output = tasks
    node.prev = this.#last

    this.#last = node

    for (const task of tasks) {
      this.tasks[task.options.name] = task
    }

    return this
  }

  as(options: any) {
    this.options = options
    return this
  }

  get first() {
    return this.#first
  }

  get last() {
    return this.#last
  }
}


