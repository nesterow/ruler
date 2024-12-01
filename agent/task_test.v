module agent

import context

struct TestTask {
	TaskBase
}

fn (t &TestTask) run(ctx context.Context) ! {
	println('TestTask.run')
	assert t.params?[0].key == 'key'
}

fn (t &TestTask) rollback(ctx context.Context) ! {
	println('TestTask.rollback')
}

fn test_task_definition() {
	task := &TestTask{
		name:   'test'
		params: [
			Params{
				key:   'key'
				value: 'value'
			},
		]
	}

	ctx := context.background()
	task.run(ctx)!
	task.rollback(ctx)!
}
