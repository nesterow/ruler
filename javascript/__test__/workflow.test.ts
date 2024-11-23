import { test } from 'bun:test'

import { Task, TaskOptions, type ITask } from '../task'
import { drawWorkflow } from '../utilities'
import { Workflow } from '../workflow'

@TaskOptions({
  name: 'test1'
})
class StandOnHead extends Task {
  async execute(): Promise<void> {

  }

  async rollback(): Promise<void> {

  }
}

test('workflow', async () => {
  const wf = new Workflow({
    name: 'main'
  })

  const wf2 = new Workflow({
    name: 'subtasks',
  })

  wf2
    .use(StandOnHead)

  wf
    .use(StandOnHead.as({
      name: 'task_name',
    }))
    .use(
      StandOnHead.as({
        name: 'what'
      }),
      StandOnHead.as({
        name: 'uniq',
      }),
      wf2
    )
    .use(StandOnHead.as({
      name: "last"
    }))

  //drawWorkflow(wf)
})
