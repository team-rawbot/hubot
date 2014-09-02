# Description:
#   Rank-me related commands
#
# Commands:
#   hubot rankme deploy <tag> - Make sure hubot still knows the rules.

{spawn, exec}  = require 'child_process'

module.exports = (robot) ->
  robot.respond /rankme deploy(.*)?/i, (msg) ->
     if msg.match[1] != undefined
        tag = msg.match[1].trim()
     else
        msg.send "For now you have to provide a tag"
        return

     command="cd /home/hubot/Repositories/rank-me && fab deploy:" + tag

     msg.send "Deploying version " + tag + " on http://www.rank-me.io"
     exec command, (err, stdout, stderr) ->
       if err
         msg.reply "Error deploying " + tag
         robot.logger.error err, stdout, stderr
       else
         msg.reply "Successfully deployed rank-me version " + tag
