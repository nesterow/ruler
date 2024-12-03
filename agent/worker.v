module agent

import context
import json
import net.http
import time

pub struct Worker {
mut:
	task_index map[string]TaskDefinition
pub:
	worker_id  string
	token      string
	server_url string
}

pub fn (mut w Worker) add_task(task TaskDefinition) {
	w.task_index[task.name] = task
}

pub fn (w Worker) get_task(name string) TaskDefinition {
	return w.task_index[name]
}

pub fn (w Worker) run_task(ctx context.Context, name string) ! {
	task := w.get_task(name)
	task.run(ctx)!
}

struct InitTask {
	name string
}

struct InitRequest {
pub:
	worker_id string
	token     string
mut:
	index []InitTask
}

fn (w Worker) init() ! {
	retry := fn [w] () ! {
		eprintln('[init] could not connect to the server. retrying in 1 seconds.')
		time.sleep(1 * time.second)
		w.init()!
	}

	mut data := InitRequest{
		worker_id: w.worker_id
		token:     w.token
	}
	for _, task in w.task_index {
		data.index << InitTask{
			name: task.name
		}
	}
	res := http.post('http://localhost:8811/init', json.encode(data)) or {
		retry()!
		return
	}
	if res.status_code != 200 {
		retry()!
		return
	}
	println('[init] worker (${w.worker_id}) has been initialized')
}

fn (w Worker) poll(ch chan Cmd) ! {
	time.sleep(2000 * time.millisecond)
	ch <- Cmd{
		id:        '1'
		worker_id: w.worker_id
		task_name: 'test'
		params:    []Params{len: 0}
	}

	res := http.get('http://localhost:8811')!
	if res.status_code != 200 {
		eprintln('[poll] could not connect to the server. reconnecting on the next iteration.')
		w.poll(ch)!
		return
	}
	println(res)
	println('next')
	w.poll(ch)!
}

pub fn run(w &Worker) {
	poll_ch := chan Cmd{}

	w.init() or { panic('could not initialize the worker') }

	spawn w.poll(poll_ch)
	for {
		select {
			cmd := <-poll_ch {
				println(cmd)
			}
		}
	}
}
