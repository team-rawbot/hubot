# Description:
#   VCA related commands
#
# Commands:
#   hubot vca deploy <server> <tag> - Deploy given tag on given server

{spawn, exec}  = require 'child_process'

module.exports = (robot) ->
  robot.respond /vca deploy (preprod|preview1|preview2) (.*)/i, (msg) ->
     server = msg.match[1]
     tag = msg.match[2].trim()

     command="cd /home/hubot/Repositories/vca && app/console deploy --tag " + tag + " " + server

     command="cd /home/krtek/Repositories/liip/vca && app/console deploy plop plop--tag " + tag + " " + server

     msg.send "Deploying version " + tag + " on http://" + server + ".vancleefarpels.com"
     exec command, (err, stdout, stderr) ->
       if err
         msg.reply "Error deploying " + tag
         robot.logger.error stdout
       else
         msg.reply "Successfully deployed rank-me version " + tag
