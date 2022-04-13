const { DataTypes, Op } = require('sequelize')

let Step
let sequelize

module.exports = {
  init: (_sequelize) => {
    sequelize = _sequelize
    sequelize.define(
      'Step',
      {
        from: DataTypes.DATE,
        to: DataTypes.DATE,
        duration: DataTypes.FLOAT,
        value: DataTypes.INTEGER,
        device: DataTypes.STRING,
      },
      {
        timestamps: false,
        defaultScope: {
          attributes: { exclude: ['id', 'UserId'] },
        },
      }
    )
    Step = sequelize.models.Step
    return Step
  },
  associate: (models) => {
    Step.belongsTo(models.User, {
      foreignKey: {
        allowNull: false,
      },
      onDelete: 'CASCADE',
    })
  },
  save: (data, userId) =>
    Promise.all(
      data.map((d) =>
        Step.create({
          ...d,
          UserId: userId,
        })
      )
    ),
  find: ({ userId, from, to }) =>
    Step.findAll({
      where: {
        UserId: userId,
        from: {
          [Op.between]: [from, to],
        },
      },
      order: [['from', 'ASC']],
    }),
}
