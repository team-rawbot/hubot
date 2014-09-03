# Description:
#   Utility commands surrounding Hubot uptime.
#
# Commands:
#   hubot ping - Reply with pong
#   hubot echo <text> - Reply back with <text>
#   hubot time - Reply with current time

{spawn, exec}  = require 'child_process'

module.exports = (robot) ->
  robot.respond /PING$/i, (msg) ->
    msg.send "PONG"

  robot.respond /ADMIN ADAPTER$/i, (msg) ->
    msg.send robot.adapterName

  robot.respond /ECHO (.*)$/i, (msg) ->
    msg.send msg.match[1]

  robot.respond /TIME$/i, (msg) ->
    msg.send "Server time is: #{new Date()}"

  robot.respond /ADMIN DIE$/i, (msg) ->
    msg.send "Goodbye, cruel world."
    process.exit 0

  robot.respond /ADMIN UPDATE/i, (msg) ->
     command="git fetch && git merge origin/master"

     msg.send "Updating hubot from https://github.com/team-rawbot/hubot"
     exec command, (err, stdout, stderr) ->
       if err
         msg.send "There was an error, see log"
         robot.logger.error err + "\n----\n" + stdout + "\n----\n" + stderr
       else
         msg.send "Successfully updated hubot"
         msg.send "Restarting ..."
         # wait some time, then restart
         setTimeout() ->
           process.exit 0
         , 1000


