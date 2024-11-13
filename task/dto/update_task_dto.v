module dto

struct UpdateTaskDTO {
	name     string
	status   int
	output   string
	metadata []TaskMetadataDTO
}
