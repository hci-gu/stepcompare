const Step = require('./Step')
const User = require('./User')

module.exports = {
  init: async (sequelize) => {
    await Promise.all([User.init(sequelize), Step.init(sequelize)])

    User.associate(sequelize.models)
    Step.associate(sequelize.models)
  },
  Step,
  User,
}
