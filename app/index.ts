import express from 'express';
import { v4 } from 'uuid';

const app: express.Application = express()
const PORT: number = 80
const id = v4()

app.get('/', (req, res) => {
  res.send(process.env)
})

app.get('/id', (req, res) => {
  res.send({ id })
})

app.listen(PORT, () => {
  console.log(`started server on ${PORT}`)
})