import { Task, TaskOptions, type ExecContext, type ITask } from '../task'


@TaskOptions({
  name: "stand_up",
  next: ['sit_down'],
  transitions: ['standing'],
})
export class StandUp extends Task {
  async execute({
    params,
    goto,
    resolve
  }: ExecContext): Promise<void> {
    //await workflow.setStatus("standing")
    console.log(params)
    await goto('sit_down')({
      time: Date.now()
    })
  }

  async rollback({ params }): Promise<void> {

  }
}



@TaskOptions({ name: "sit_down" })
class SitDown extends Task {
  async execute(): Promise<void> {
    console.log('Executing sit_down')
  }

  async rollback(): Promise<void> {

  }
}



@TaskOptions({ name: "lay_down" })
class LayDown extends Task {
  async execute(): Promise<void> {

  }

  async rollback(): Promise<void> {

  }
}



@TaskOptions({ name: "roll_over" })
class RollOver extends Task {
  async execute(): Promise<void> {

  }

  async rollback(): Promise<void> {

  }
}


@TaskOptions({ name: "play_dead" })
class PlayDead extends Task {
  async execute(): Promise<void> {

  }

  async rollback(): Promise<void> {

  }
}

