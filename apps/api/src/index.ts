import { Hono } from 'hono'
import { cors } from 'hono/cors'

const app = new Hono()

app.use('*', cors())

app.get('/', (c) => {
  return c.json({ message: 'Contrail API', status: 'ok' })
})

app.get('/health', (c) => {
  return c.json({ status: 'healthy' })
})

export default app
