module rest

import agent
import json
import veb

@['/init'; post]
pub fn (r &Rest) agent_init_route(mut ctx veb.Context) veb.Result {
	// TODO: env for db url
	mut agent_repo := agent.create_agent_repo(':memory:') or {
		return ctx.server_error('could not connect to the agent repo')
	}
	defer {
		agent_repo.close()
	}
	req := json.decode(agent.InitRequest, ctx.req.data) or {
		return ctx.server_error('could not parse request')
	}

	agent_repo.create(agent.Agent{
		id: req.worker_id,
		access_token: '123'
	}) or {
		// could not create or exists
	}
	println(req)
	return ctx.not_found()
}
