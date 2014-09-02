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

     c="cd /home/hubot/Repositories/rank-me && fab deploy:" + tag

     msg.send "Deploying " + tag
     exec c, (err, stdout, stderr) ->
       if err
         msg.reply "Error deploying rank-me : "
         msg.send(line) for line in err.toString().split("\n")
       else
         msg.reply "Successfully deployed rank-me version " + tag
