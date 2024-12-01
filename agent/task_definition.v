module agent

import context

pub struct Params {
	key   string
	value string
}

pub interface TaskDefinition {
	id     ?string
	name   string
	params ?[]Params
	run(ctx context.Context) !
	rollback(ctx context.Context) !
}

pub struct TaskBase {
pub:
	id     ?string
	name   string
	params ?[]Params
}
