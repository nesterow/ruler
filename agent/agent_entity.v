module agent

import time

/*
Agent represents a single agent distinct by an id and access token.
The agent id may be a human readable string, so we use access_token in order to identify the agent.
The access token is set by an angent on the first connection to prevent hijaking.
*/
@[table: 'agents']
pub struct Agent {
pub:
	id           string @[primary]
	ip           ?string
	hostname     ?string
	access_token string    @[required; unique]
	last_seen    time.Time @[default: 'CURRENT_TIME']
	created_at   time.Time @[default: 'CURRENT_TIME']
}
