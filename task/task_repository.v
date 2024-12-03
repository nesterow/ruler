module task

interface TaskRepository {
	seed() !
	create(task Task) !
	log(log ExecutionLog) !
mut:
	close()
}

pub fn create_task_repo(connection_url string) !&TaskRepository {
	match true {
		connection_url.starts_with('file:') {
			return TaskSQLiteRepo.new(connection_url)
		}
		connection_url.starts_with(':memory:') {
			return TaskSQLiteRepo.new(connection_url)
		}
		else {
			return error('Unsupported connection URL')
		}
	}
}
