module task

import veb


pub struct TaskVebContext {
	veb.Context
}

pub struct TaskVebController {}

pub fn (ctrl &TaskVebController) index(mut ctx TaskVebContext) veb.Result {
    return ctx.text('from task')
}
