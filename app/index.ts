import express = require('express')

const app: express.Application = express()
const PORT: number = 80

app.get('/', (req, res) => {
  res.send(process.env)
})

app.listen(PORT, () => {
  console.log(`started server on ${PORT}`)
})