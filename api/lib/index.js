require('dotenv').config()
const express = require('express')
const cors = require('cors')
const { User, Step } = require('./db')

const app = express()
app.use(cors())
app.use(express.json({ limit: '50mb' }))

app.post('/users', async (req, res) => {
  const user = await User.save()

  res.send(user.dataValues)
})

app.get('/users/:id', async (req, res) => {
  const { id } = req.params
  const user = await User.get(id)

  console.log('GET user', user)

  res.send(user)
})

app.post('/users/:id/steps', async (req, res) => {
  const { id } = req.params
  console.log('upload steps', id)
  const steps = req.body

  await Step.save(steps, id)

  res.sendStatus(200)
})

app.get('/users/:id/steps', async (req, res) => {
  const { id } = req.params
  const { from, to } = req.query

  const steps = await Step.find({ userId: id, from, to })

  res.send(steps)
})

app.listen(4000, () => console.log('listening on port 4000'))
