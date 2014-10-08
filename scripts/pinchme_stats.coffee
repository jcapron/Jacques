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
  pm_access_token = process.env.HUBOT_PINCHME_API_TOKEN
  pm_base_url = "https://www.pinchme.com/api/v1/"

  robot.respond /how many users/i, (msg) ->
    pm_url = pm_base_url + "users/population?access_token=" + pm_access_token
    msg.http(pm_url)
      .get() (err, res, body) ->
        total = JSON.parse(body).number
        response = "There are " + total + " users!"
        msg.send response

  robot.respond /gender breakdown/i, (msg) ->
    pm_url = pm_base_url + "users/gender_avg?access_token=" + pm_access_token
    msg.http(pm_url)
      .get() (err, res, body) ->
        male = JSON.parse(body).chart[0].value
        female = 100 - male
        response = "Gender breakdown:\n
        - Female: " + female + "%\n
        - Male: " + male + "%"
        msg.send response

  robot.respond /age breakdown/i, (msg) ->
    pm_url = pm_base_url + "users/age_avg?access_token=" + pm_access_token
    msg.http(pm_url)
      .get() (err, res, body) ->
        _16_24 = JSON.parse(body).chart[0].value
        _25_34 = JSON.parse(body).chart[1].value
        _35_44 = JSON.parse(body).chart[2].value
        _45_54 = JSON.parse(body).chart[3].value
        _55_64 = JSON.parse(body).chart[4].value
        _65_plus = JSON.parse(body).chart[5].value
        total = _16_24 + _25_34 + _35_44 + _45_54 + _55_64 + _65_plus
        response = "Age breakdown:\n
        - 16-24: " + _16_24 + "%\n
        - 25-34: " + _25_34 + "%\n
        - 35-44: " + _35_44 + "%\n
        - 45-54: " + _45_54 + "%\n
        - 55-64: " + _55_64 + "%\n
        - 65+: " + _65_plus + "%"
        msg.send response
