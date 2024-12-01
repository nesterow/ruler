module task

import time

/*
* pipeline - a sequence of tasks that proceeds execution from the latest task
* saga - a sequence of tasks that must be rolled back on a failure
*/
enum ExecutionType {
	pipeline
	saga
}

enum ExecutionStatus {
	should_start
	running
	paused
	succeeded
	rolling_back
	rolled_back
	failed
}

enum TaskStatus {
	created
	should_start
	running
	succeeded
	should_rollback
	rolling_back
	rolled_back
	failed
}

@[table: 'task_metadata']
struct TaskMetadata {
	id         string @[primary]
	task_id    string
	key        string
	value      string
	created_at time.Time @[default: 'CURRENT_TIME']
	updated_at time.Time @[default: 'CURRENT_TIME']
}

@[table: 'tasks']
struct Task {
	id        string @[primary]
	agent_id  string
	ref       string
	name      string
	parent_id string
	input     string
	output    string
	status    TaskStatus
	metadata  []TaskMetadata @[fkey: 'task_id']
}

@[table: 'execution_logs']
struct ExecutionLog {
	id         string @[primary]
	parent_id  string
	task_id    ?string
	status     ExecutionStatus
	text       string
	created_at time.Time @[default: 'CURRENT_TIME']
}

@[table: 'executions']
struct Execution {
	id     string @[primary]
	status ExecutionStatus
	type   ExecutionType
	logs   []ExecutionLog @[fkey: 'parent_id']
	tasks  []Task         @[fkey: 'parent_id']
}
