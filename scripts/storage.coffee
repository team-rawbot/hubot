# Description:
#   Inspect the data in redis easily

Util = require "util"

module.exports = (robot) ->
  robot.respond /admin show storage$/i, (msg) ->
    output = Util.inspect(robot.brain.data, false, 4)
    msg.send output

  robot.respond /admin show users$/i, (msg) ->
    response = ""

    for own key, user of robot.brain.data.users
      response += "#{user.id} #{user.name}"
      response += " <#{user.email_address}>" if user.email_address
      response += "\n"

    msg.send response

