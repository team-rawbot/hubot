# Description:
#   Rank-me related commands
#
# Commands:
#   hubot rankme deploy <tag> - Deploy rank-me given tag
#   hubot rankme competitions - List all competitions
#   hubot rankme teams - List all teams
#   hubot rankme result <winner> <looser> - Enter a result into the default competition
#   hubot rankme result <winner> <looser> into <competition> - Enter a result into the given competition

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
     msg.send "Getting competition list ..."
     robot.http(api + 'competitions/?page_size=100')
         .header('accept', 'application/json')
         .header('Authorization', 'Token ' + process.env.RANKME_TOKEN)
         .get() (err, res, body) ->
           json = JSON.parse(body)
           message = []
           if json.results
             message.push "#{c.name} [#{c.slug}]" for c in json.results
             message.push "------"
           else
             message.push "Error : " + body
           msg.send message.join "\n"

  robot.respond /rankme teams/i, (msg) ->
     msg.send "Getting team list ..."
     robot.http(api + 'teams/?page_size=100')
         .header('accept', 'application/json')
         .header('Authorization', 'Token  ' + process.env.RANKME_TOKEN)
         .get() (err, res, body) ->
           json = JSON.parse(body)
           message = []
           if json.results
             message.push "#{t.name} - #{t.competitions}" for t in json.results
             message.push "------"
           else
             message.push "Error : " + body
           msg.send message.join "\n"

  robot.respond /rankme result ([^ ]*) ([^ ]*)( into ([^ ]*))?/i, (msg) ->
     if msg.match[4]?
       competition =  msg.match[4]
     else
       competition = 'default-competition'

     payload = {
        'competition': competition,
        'winner': msg.match[1],
        'looser': msg.match[2]
     }

     msg.send "Sending results ..."
     robot.http(api + 'results/add/')
         .header('accept', 'application/json')
         .header('Content-Type', 'application/json')
         .header('Authorization', 'Token  ' + process.env.RANKME_TOKEN)
         .post(JSON.stringify(payload)) (err, res, body) ->
           json = JSON.parse(body)

           if json.status != 'success'
             msg.send "Error : " + body
