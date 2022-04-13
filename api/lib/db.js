const { DB_HOST, DB_USERNAME, DB_PASSWORD, DB } = process.env
const [host, port] = DB_HOST.split(':')

const { Sequelize } = require('sequelize')
const models = require('./models')

const sequelize = new Sequelize({
  define: {
    defaultScope: {
      attributes: {
        exclude: ['created_at', 'updated_at'],
      },
    },
  },
  dialect: 'postgres',
  logging: false,
  database: DB,
  username: DB_USERNAME,
  password: DB_PASSWORD,
  host,
  port,
})

const init = async () => {
  await models.init(sequelize)
  await sequelize.sync()
}
init()

module.exports = {
  sequelize,
  ...models,
}
