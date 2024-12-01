module main

import rest
import agent

fn main() {

	database_url := ':memory:'
	mut agent_repo := agent.create_agent_repo(database_url) or {
		panic('could not create agent repo')
	}

	agent_repo.seed() or {
		panic('could not seed agent repo')
	}
	agent_repo.close()

	rest.serve()!
}
