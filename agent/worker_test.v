module agent

import context

struct TestTask {
	TaskBase
}

fn (t &TestTask) run(ctx context.Context) ! {
	println('worker.TestTask.run')
}

fn (t &TestTask) rollback(ctx context.Context) ! {
	println('worker.TestTask.rollback')
}

fn test_worker() {
	mut w := Worker{
		worker_id: 'test'
	}

	w.add_task(TestTask{
		name:   'test1'
		params: []Params{len: 0}
	})

	w.add_task(TestTask{
		name: 'test2'
	})

	ctx := context.background()

	w.run_task(ctx, 'test2')!
	// run(w)
}
