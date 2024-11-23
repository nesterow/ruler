import { test } from 'bun:test'
import { Worker } from '../worker'
import './tasks.mock'
import { WorkerMockProvider } from './worker.mock.provider'

test('worker', async () => {
  const provider = new WorkerMockProvider()
  const worker = new Worker({
    id: 'test',
    provider,
  })
  await new Promise((r) => setTimeout(r, 1000))
})
