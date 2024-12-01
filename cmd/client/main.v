module main

import client
import agent

fn main() {
	mut w := agent.Worker{
		worker_id: 'worker'
	}
	w.add_task(client.ExecTask{
		name: 'exec'
	})
	agent.run(w)
}
