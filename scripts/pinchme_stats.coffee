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
#   hubot age breakdown - Gives the age breakdown
#   hubot gender breakdown - Gives the gender breakdown
#
# Author:
#   jcapron


module.exports = (robot) ->
  pm_access_token = process.env.HUBOT_PINCHME_API_TOKEN
  pm_base_url = "https://www.pinchme.com/api/v1/"

  numberWithCommas = (x) ->
    x.toString().replace /\B(?=(\d{3})+(?!\d))/g, ","

  robot.respond /how many users/i, (msg) ->
    pm_url = pm_base_url + "users/population?access_token=" + pm_access_token
    msg.http(pm_url)
      .get() (err, res, body) ->
        total = JSON.parse(body).number
        response = "There are " + numberWithCommas(total) + " users!"
        msg.send response

  robot.respond /gender breakdown/i, (msg) ->
    pm_url = pm_base_url + "users/gender_avg?access_token=" + pm_access_token
    msg.http(pm_url)
      .get() (err, res, body) ->
        male = JSON.parse(body).chart[0].value
        female = 100 - male
        response = "Gender breakdown:\n" +
        "- Female: " + Math.round(female) + "%\n" +
        "- Male: " + Math.round(male) + "%"
        msg.send response

  robot.respond /age breakdown/i, (msg) ->
    pm_url = pm_base_url + "users/age_avg?access_token=" + pm_access_token
    msg.http(pm_url)
      .get() (err, res, body) ->
        json = JSON.parse(body)
        _16_24 = json.chart[0].value
        _25_34 = json.chart[1].value
        _35_44 = json.chart[2].value
        _45_54 = json.chart[3].value
        _55_64 = json.chart[4].value
        _65_plus = json.chart[5].value
        total = _16_24 + _25_34 + _35_44 + _45_54 + _55_64 + _65_plus
        response = "Age breakdown:\n" +
        "- 16-24: " + Math.round(_16_24*100/total) + "%\n" +
        "- 25-34: " + Math.round(_25_34*100/total) + "%\n" +
        "- 35-44: " + Math.round(_35_44*100/total) + "%\n" +
        "- 45-54: " + Math.round(_45_54*100/total) + "%\n" +
        "- 55-64: " + Math.round(_55_64*100/total) + "%\n" +
        "- 65+: " + Math.round(_65_plus*100/total) + "%"
        msg.send response
