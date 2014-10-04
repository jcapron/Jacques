# Description:
#   Fuck it, we'll do it live!
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   do it live - F*ck it, we'll do it live!
#
# Author:
#   stewart

module.exports = (robot) ->
  robot.hear /do it live/i, (msg) ->
    msg.send "http://rationalmale.files.wordpress.com/2011/09/doitlive.jpeg"
