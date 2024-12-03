module task

import veb

pub struct TaskVebContext {
	veb.Context
}

pub struct TaskVebController {
pub:
	tasks TaskRepository
}

pub fn (ctrl &TaskVebController) index(mut ctx TaskVebContext) veb.Result {
	return ctx.text('from task')
}

@[post]
pub fn (ctrl &TaskVebController) create_index(mut ctx TaskVebContext) veb.Result {
	println(ctx.form)
	return ctx.text('test')
}
