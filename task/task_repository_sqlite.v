module task

import db.sqlite

struct TaskSQLiteRepo {
mut:
	db sqlite.DB
}

fn TaskSQLiteRepo.new(database_url string) !&TaskRepository {
	db := sqlite.connect(database_url)!
	return &TaskSQLiteRepo{
		db: db
	}
}

pub fn (mut t TaskSQLiteRepo) close() {
	t.db.close() or { panic(err) }
}

pub fn (t TaskSQLiteRepo) migrate() ! {
	sql t.db {
		create table TaskMetadata
		create table Task
		create table ExecutionLog
		create table Execution
	}!
}

pub fn (t TaskSQLiteRepo) log(log ExecutionLog) ! {
	sql t.db {
		insert log into ExecutionLog
	}!
}

pub fn (t TaskSQLiteRepo) create(r Task) ! {
	sql t.db {
		insert r into Task
	}!
}
