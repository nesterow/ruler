module agent

pub interface AgentRepository {
	seed() !
	find() ![]Agent
	get_one(id string) !Agent
	get_one_by_token(token string) !Agent
	create(data Agent) !
	update(data Agent) !
	delete(id string) !
	set_online(id string) !
mut:
	close()
}

pub fn create_agent_repo(connection_url string) !&AgentRepository {
	match true {
		connection_url.starts_with('file:') {
			return AgentSQLiteRepo.new(connection_url)
		}
		connection_url.starts_with(':memory:') {
			return AgentSQLiteRepo.new(connection_url)
		}
		else {
			return error('Unsupported connection URL')
		}
	}
}
