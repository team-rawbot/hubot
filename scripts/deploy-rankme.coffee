# deploy <branch> to stage - deploy the branch to stage

{spawn, exec}  = require 'child_process'

module.exports = (robot) ->
  robot.respond /deploy rank-me(.*)?/i, (msg) ->
     if msg.match[1] != undefined
        tag = msg.match[1].trim()
     else
        msg.send "For now you have to provide a tag"
        return

     c="cd /home/hubot/Repositories/rank-me && fab deploy:" + tag

     msg.send "Deploying " + tag
     exec c, (err, stdout, stderr) ->
       if err
         msg.send "Error deploying rank-me : "
         msg.send err
       else
         msg.send "Successfully deployed rank-me"
