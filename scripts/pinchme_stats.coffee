# Description:
#   PINCHme stats
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_PINCHME_API_TOKEN: access token to PINCHme API
#
# Commands:
#   hubot how many users - Gives the total of PINCHme users
#
# Author:
#   jcapron

module.exports = (robot) ->

  robot.respond /how many users/i, (msg) ->
    access_token = process.env.HUBOT_PINCHME_API_TOKEN
    url = "https://www.pinchme.com/api/v1/users/population?access_token=" + access_token
    msg.http(url)
      .get() (err, res, body) ->
        total = JSON.parse(body).number
        response = "There are " + total + " users!"
        msg.send response
