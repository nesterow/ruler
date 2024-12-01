module client

import agent
import context

pub struct ExecTask {
	agent.TaskBase
}

fn (t &ExecTask) run(ctx context.Context) ! {
	println('ExecTask.run')
}

fn (t &ExecTask) rollback(ctx context.Context) ! {
	println('ExecTask.rollback')
}
