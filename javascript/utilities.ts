import { Workflow } from "./workflow";

export function drawWorkflow(wf: Workflow, indent = 0, sym = '┄') {
	let current = wf.first;
	const padding = [...new Array(indent).fill(' ')]
	const { name: wfName, when: wfWhen } = wf.options
	const wfMode = `[run when (${wfWhen ?? 'always'})]`
    
	console.log('\x1b[35m', ...padding, sym, wfName, wfMode, '\x1b[0m')
    
	for (; ;) {
		if (!current) break
		const pad = [...padding]
		if ((current?.output?.length ?? 0) > 1) {
			pad.push(' ')
		}
		if (indent > 0) {
			pad.push(' ')
		}
		for (const task of current?.output ?? []) {
			const { name, when } = task.options
			if (task instanceof Workflow) {
				drawWorkflow(task, 1 + indent, '-')
			} else {
				const tMode = `[run when (${when ?? 'always'})]`
				console.log('', ...pad, '-', name, tMode)
			}
		}
		current = current?.next ?? null
	}
	if (indent === 0) console.log("--------------------------\n")
}
