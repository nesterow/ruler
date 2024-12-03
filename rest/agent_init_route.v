module rest

import agent
import json
import veb

@['/init'; post]
pub fn (r &Rest) agent_init_route(mut ctx veb.Context) veb.Result {
	req := json.decode(agent.InitRequest, ctx.req.data) or {
		return ctx.server_error('could not parse request')
	}

	r.agents.create(agent.Agent{
		id:    req.worker_id
		token: req.token
	}) or { eprintln(err.msg()) }
	//println(req)
	return ctx.not_found()
}
