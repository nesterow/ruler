module rest

import veb
import task
import agent

pub struct Context {
	veb.Context
}

pub struct Rest {
	veb.Controller
	agents agent.AgentRepository
	tasks  task.TaskRepository
}

@[params]
pub struct ServerOptions {
	port         int    = 8811
	database_url string = ':memory:'
}

pub fn serve(opts ServerOptions) ! {
	mut agent_repo := agent.create_agent_repo(opts.database_url) or {
		return error('could not create agent repo')
	}

	mut task_repo := task.create_task_repo(opts.database_url) or {
		return error('could not create task repo')
	}

	mut app := Rest{
		agents: agent_repo
		tasks:  task_repo
	}

	defer {
		agent_repo.close()
		task_repo.close()
	}

	agent_repo.seed() or { panic('could not seed agent repo') }
	task_repo.seed() or { panic('could not seed task repo') }

	mut task_controller := &task.TaskVebController{
		tasks: task_repo
	}
	app.register_controller[task.TaskVebController, task.TaskVebContext]('/task', mut
		task_controller)!

	veb.run[Rest, Context](mut app, opts.port)
}
