module task

fn should_pass_any_impl(connection_url string) ! {
	mut repo := create_task_repo(connection_url)!
	repo.migrate()!
	defer {
		repo.close()
	}
	repo.log(ExecutionLog{
		parent_id: ''
		task_id:   'test'
		status:    ExecutionStatus.should_start
		text:      'test'
	})!
	assert 1 == 1
}

fn test_task_repository() {
	should_pass_any_impl(':memory:')!
}
