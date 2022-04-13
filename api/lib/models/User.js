const { DataTypes } = require('sequelize')

let User
module.exports = {
  init: (sequelize) => {
    sequelize.define(
      'User',
      {
        id: {
          type: DataTypes.UUID,
          defaultValue: DataTypes.UUIDV4,
          unique: true,
          primaryKey: true,
        },
        createdAt: { type: DataTypes.DATE, defaultValue: DataTypes.NOW },
      },
      {
        timestamps: false,
      }
    )
    User = sequelize.models.User

    return User
  },
  associate: (models) => {
    User.hasMany(models.Step, {
      onDelete: 'cascade',
    })
  },
  save: () => User.create({}),
  get: (id) => User.findOne({ where: { id } }),
}
