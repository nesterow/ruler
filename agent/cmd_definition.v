module agent

import json

pub interface CmdDefinition {
	id        string
	worker_id string
	task_name string
	params    Params
	from_json(data string) !
	to_json() string
}

pub struct Cmd {
	id        string
	worker_id string
	task_name string
	params    ?[]Params
}

pub fn (mut cmd Cmd) from_json(data string) ! {
	cmd = json.decode(Cmd, data)!
}

pub fn (cmd &Cmd) to_json() string {
	return json.encode_pretty(cmd)
}
