module dto

pub struct TaskMetadataDTO {
pub:
	key   string @[required]
	value string
}

pub struct CreateTaskDTO {
pub:
	id        string @[required]
	ref       string
	name      string
	parent_id string
	input     string
	metadata  []TaskMetadataDTO
}
