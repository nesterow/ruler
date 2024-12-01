module agent

fn should_pass_any_impl(connection_url string) ! {
	mut repo := create_agent_repo(connection_url)!
	repo.seed()!
	defer {
		repo.close()
	}

	repo.create(Agent{
		id:           'agent'
		access_token: '123'
	})!

	agents := repo.find()!
	assert agents.len == 1

	agent_by_id := repo.get_one('agent')!
	assert agent_by_id.id == 'agent'

	agent_by_token := repo.get_one_by_token('123')!
	assert agent_by_token.id == 'agent'

	agent_error := repo.get_one('not_found') or {
		assert err.msg() == 'agent not found'
		return
	}

	repo.update(Agent{
		id:           'agent'
		access_token: '1234'
	})!

	agent_upd := repo.get_one_by_token('1234')!
	assert agent_upd.id == 'agent'

	repo.set_online('1234')!

	repo.delete('agent')!
}

fn test_task_repository() {
	should_pass_any_impl(':memory:')!
}
