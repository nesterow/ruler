module main

import rest

fn main() {
	println("Starting server on port 8811")
	rest.serve()!
}
