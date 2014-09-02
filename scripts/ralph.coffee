# Description:
#   None
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   ralph - Shows a picture of Alf
#   robin - Shows something
#
# Author:
#   tbwIII

ralphs = [
	"http://media.giphy.com/media/aRspiC2CRok1y/giphy.gif",
	"http://media.giphy.com/media/IlsWkT2IgaHO8/giphy.gif",
	"http://media.giphy.com/media/Ej51ffWK8qyDm/giphy.gif",
	"http://media.giphy.com/media/t0nm9DeDSzllK/giphy.gif",
	"http://media.giphy.com/media/11gfHdp3yaGwda/giphy.gif"
]

module.exports = (robot) ->
  robot.hear /(^|\W)ralph(\z|\W|$)/i, (msg) ->
    msg.send msg.random ralphs
