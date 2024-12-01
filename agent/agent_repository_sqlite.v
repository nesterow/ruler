module agent

import db.sqlite

pub struct AgentSQLiteRepo {
mut:
	db sqlite.DB
}

fn AgentSQLiteRepo.new(connection_url string) !&AgentRepository {
	db := sqlite.connect(connection_url)!
	return &AgentSQLiteRepo{
		db: db
	}
}

pub fn (mut a AgentSQLiteRepo) close() {
	a.db.close() or { panic(err) }
}

pub fn (a AgentSQLiteRepo) seed() ! {
	sql a.db {
		create table Agent
	}!
}

pub fn (a AgentSQLiteRepo) get_one(id string) !Agent {
	agents := sql a.db {
		select from Agent where id == id
	}!
	if agents.len == 0 {
		return error('agent not found')
	}
	return agents[0]
}

pub fn (a AgentSQLiteRepo) get_one_by_token(token string) !Agent {
	agents := sql a.db {
		select from Agent where access_token == token
	}!
	if agents.len == 0 {
		return error('agent not found')
	}
	return agents[0]
}

pub fn (a AgentSQLiteRepo) find() ![]Agent {
	agents := sql a.db {
		select from Agent
	}!
	return agents
}

pub fn (a AgentSQLiteRepo) create(data Agent) ! {
	sql a.db {
		insert data into Agent
	}!
}

pub fn (a AgentSQLiteRepo) update(data Agent) ! {
	sql a.db {
		update Agent set access_token = data.access_token where id == data.id
	}!
}

pub fn (a AgentSQLiteRepo) delete(id string) ! {
	sql a.db {
		delete from Agent where id == id
	}!
}

pub fn (a AgentSQLiteRepo) set_online(access_token string) ! {
	sql a.db {
		update Agent set last_seen = 'CURRENT_TIME' where access_token == access_token
	}!
}
