module rest

import veb
import task

pub struct Context {
	veb.Context
}

pub struct Rest {
	veb.Controller
}

@[params]
pub struct ServerOptions {
	port int = 8811
}

pub fn serve(opts ServerOptions) ! {
	mut app := Rest{}

	mut task_controller := &task.TaskVebController{}
	app.register_controller[task.TaskVebController, task.TaskVebContext]('/task', mut
		task_controller)!

	veb.run[Rest, Context](mut app, opts.port)
}
