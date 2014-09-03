# Description:
#   Rank-me related commands
#
# Commands:
#   hubot rankme deploy <tag> - Deploy rank-me given tag
#   hubot rankme competitions - List all competitions
#   hubot rankme teams - List all teams

{spawn, exec}  = require 'child_process'

server = 'http://www.rank-me.io'
api = server + '/api/'

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
         robot.logger.error err + "\n----\n" + stdout + "\n----\n" + stderr
       else
         msg.reply "Successfully deployed rank-me version " + tag

  robot.respond /rankme competitions/i, (msg) ->
     robot.http(api + 'competitions/?page_size=100')
         .header('accept', 'application/json')
         .header('Authorization', 'Token ' + process.env.RANKME_TOKEN)
         .get() (err, res, body) ->
           json = JSON.parse(body)
           if json.results
             msg.send "#{c.name}" for c in json.results
           else
             msg.send "error"

  robot.respond /rankme teams/i, (msg) ->
     robot.http(api + 'teams/?page_size=100')
         .header('accept', 'application/json')
         .header('Authorization', 'Token  ' + process.env.RANKME_TOKEN)
         .get() (err, res, body) ->
           json = JSON.parse(body)
           if json.results
             msg.send "#{t.name} - #{t.competitions}" for t in json.results
           else
             msg.send "error"

###
  robot.respond /rankme enter ([^ ]*) ([^ ]*)( into ([^ ]*))?/i, (msg) ->
     winner = msg.match[1]
     looser = msg.match[2]
     if msg.match[4] != undefined
       competition = msg.match[4]
     else
       competition = 'default-competition'

     console.log(winner, looser, competition)
###