# Description:
#   PINCHme stats
#
# Dependencies:
#   "mandrill-api":">=1.0.2"
#
# Configuration:
#   HUBOT_PINCHME_API_TOKEN: access token to PINCHme API
#
# Commands:
#   hubot how many users - Gives the total of users
#   hubot gender breakdown - Gives the gender breakdown
#   hubot age breakdown - Gives the age breakdown
#   hubot active users breakdown - Gives the active users breakdown
#   hubot sample breakdown - Gives the sample breakdown (only works in a room, not in private conversations)
#   hubot items per box - Gives the items per box breakdown (only works in a room, not in private conversations)
#   hubot advanced profiles completed - Gives the number of advanced profiles completed
#   hubot samples claimed - Gives the number of  samples claimed
#   hubot boxes ordered - Gives the number of boxes ordered
#   hubot surveys completed - Gives the surveys breakdown
#   hubot did you buy breakdown - Gives the did you buy breakdown
#
# Author:
#   jcapron


module.exports = (robot) ->
  pm_access_token = process.env.HUBOT_PINCHME_API_TOKEN
  pm_base_url = process.env.PM_BASE_URL

  numberWithCommas = (x) ->
    x.toString().replace /\B(?=(\d{3})+(?!\d))/g, ","

  printHtmlTable = (table) ->
    result = "<table>"
    for row, i in table
      result = result + "<tr>"
      for column, j in table[i]
        if i == 0
          result = result + "<td><b>" + encodeURIComponent(table[i][j]).replace(/'/, '') + "</b></td>"
        else
          result = result + "<td>" + encodeURIComponent(table[i][j]).replace(/'/, '') + "</td>"
      result = result + "</tr>"
    result = result + "</table>"
    result

  curlThis = (message, room) ->
    hipchat_token = process.env.HUBOT_HIPCHAT_AUTH_TOKEN
    puts = ( error, stdout, stderr) ->
      sys.puts stdout
      return
    sys = require("sys")
    exec = require("child_process").exec
    switch room
      when "pinchme" then room = "PINCHme+Tech+Team"
      when "pinchme_us" then room = "PINCHme+US"
      when "frere_jacques" then room = "Frere+Jacques"
    exec "curl -X POST --data 'auth_token=#{hipchat_token}&room_id=#{room}&from=Jacques&message_format=html&message=#{message}' https://api.hipchat.com/v1/rooms/message", puts

  emailThis = (content, subject, name, file) ->
    email = getEmailFromUser(name)
    mandrill = require 'mandrill-api/mandrill'
    mandrill_client = new mandrill.Mandrill(process.env.MANDRILL_APIKEY)
    message =
      html: content
      subject: subject
      from_email: "no-reply-to-Jacques@hipchat.com"
      from_name: "Jacques Bot"
      to: [
        email: email
        name: name
        type: "to"
      ]
      attachments: [
        type: "text/csv"
        name: subject + ".csv"
        content: file
      ]
    async = false
    mandrill_client.messages.send
      message: message
      async: async
    , ((result) ->
      console.log result
      return 1
    ), (e) ->
      # Mandrill returns the error as an object with name and message keys
      console.log "A mandrill error occurred: " + e.name + " - " + e.message
      return

  robot.respond /how many users/i, (msg) ->
    pm_url = pm_base_url + "users/total_active_users?access_token=" + pm_access_token
    msg.http(pm_url)
      .get() (err, res, body) ->
        total = JSON.parse(body).number
        response = "There are #{numberWithCommas(total)} users!"
        msg.send response

  robot.respond /gender breakdown/i, (msg) ->
    pm_url = pm_base_url + "users/gender_avg?access_token=" + pm_access_token
    msg.http(pm_url)
      .get() (err, res, body) ->
        male = JSON.parse(body).chart[0].value
        female = 100 - male
        response = "Gender breakdown:\n" +
        "- Female: #{Math.round(female)}%\n" +
        "- Male: #{Math.round(male)}%"
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
        "- 16-24: #{Math.round(_16_24*100/total)}%\n" +
        "- 25-34: #{Math.round(_25_34*100/total)}%\n" +
        "- 35-44: #{Math.round(_35_44*100/total)}%\n" +
        "- 45-54: #{Math.round(_45_54*100/total)}%\n" +
        "- 55-64: #{Math.round(_55_64*100/total)}%\n" +
        "- 65+: #{Math.round(_65_plus*100/total)}%"
        msg.send response

  robot.respond /active users breakdown/i, (msg) ->
    pm_url = pm_base_url + "users/mobile_verified_breakdown?access_token=" + pm_access_token
    msg.http(pm_url)
      .get() (err, res, body) ->
        json = JSON.parse(body)
        mobile_verified_total = json.chart[0].value
        mobile_verified_ordered_past_month = json.chart[1].value
        mobile_verified_signed_in_past_month = json.chart[2].value
        response = "Active users breakdown:\n" +
        "- Total: #{numberWithCommas(mobile_verified_total)}\n" +
        "- Ordered past month: #{numberWithCommas(mobile_verified_ordered_past_month)}\n" +
        "- Signed in past month: #{numberWithCommas(mobile_verified_signed_in_past_month)}"
        msg.send response

  robot.respond /sample breakdown/i, (msg) ->
    pm_url = pm_base_url + "conversions/live_campaign_sample_breakdown?access_token=" + pm_access_token
    msg.http(pm_url)
      .get() (err, res, body) ->
        json = JSON.parse(body)
        table = json.table
        response = printHtmlTable(table)
        curlThis("Inventory breakdown:\n" + response, encodeURIComponent(msg.message.room))

  robot.respond /(how many )?items per box/i, (msg) ->
    pm_url = pm_base_url + "conversions/samples_per_box_breakdown?access_token=" + pm_access_token
    msg.http(pm_url)
      .get() (err, res, body) ->
        json = JSON.parse(body)
        table = json.table
        response = printHtmlTable(table)
        curlThis("Samples per box for current campaigns:\n" + response, encodeURIComponent(msg.message.room))

  robot.respond /(how many )?advanced profiles completed/i, (msg) ->
    pm_url = pm_base_url + "conversions/profiles_complete?access_token=" + pm_access_token
    msg.http(pm_url)
      .get() (err, res, body) ->
        json = JSON.parse(body)
        total = JSON.parse(body).number
        response = "#{numberWithCommas(total)} advanced profiles completed overall"
        msg.send response

  robot.respond /(how many )?samples claimed/i, (msg) ->
    pm_url = pm_base_url + "conversions/samples_claimed?access_token=" + pm_access_token
    msg.http(pm_url)
      .get() (err, res, body) ->
        json = JSON.parse(body)
        total = JSON.parse(body).number
        response = "#{numberWithCommas(total)} samples claimed"
        msg.send response

  robot.respond /(how many )?boxes ordered/i, (msg) ->
    pm_url = pm_base_url + "conversions/boxes_ordered?access_token=" + pm_access_token
    msg.http(pm_url)
      .get() (err, res, body) ->
        json = JSON.parse(body)
        total = JSON.parse(body).number
        response = "#{numberWithCommas(total)} boxes ordered"
        msg.send response

  robot.respond /(how many )?surveys completed/i, (msg) ->
    response = ""
    pm_url = pm_base_url + "conversions/survey_completion_percentage?access_token=" + pm_access_token
    msg.http(pm_url)
      .get() (err, res, body) ->
        json = JSON.parse(body)
        total = JSON.parse(body).number
        response = "- #{Math.round(total)}% surveys completed\n"
        pm_url = pm_base_url + "conversions/surveys_complete_timeline?access_token=" + pm_access_token
        msg.http(pm_url)
          .get() (err, res, body) ->
            json = JSON.parse(body)
            total = JSON.parse(body)[0].number
            response = response + "- #{numberWithCommas(total)} surveys completed\n"
            pm_url = pm_base_url + "conversions/surveys_incomplete_timeline?access_token=" + pm_access_token
            msg.http(pm_url)
              .get() (err, res, body) ->
                json = JSON.parse(body)
                total = JSON.parse(body)[0].number
                response = response + "- #{numberWithCommas(total)} surveys incompleted"
                msg.send response

  robot.respond /did you buy breakdown/i, (msg) ->
    pm_url = pm_base_url + "conversions/did_you_buy_breakdown?access_token=" + pm_access_token
    msg.http(pm_url)
      .get() (err, res, body) ->
        json = JSON.parse(body)
        not_responded = json.chart[0].value
        yeses = json.chart[1].value
        nos = json.chart[2].value
        maybes = json.chart[3].value
        total = not_responded + yeses + nos + maybes
        response = "Did you buy breakdown:\n" +
        "- Yes: #{numberWithCommas(yeses)}\n" +
        "- Maybe: #{numberWithCommas(maybes)}\n" +
        "- No: #{numberWithCommas(nos)}\n" +
        "- Not answered: #{numberWithCommas(not_responded)}\n" +
        "- Total: #{numberWithCommas(nos)}"
        msg.send response

  getEmailFromUser = (name) ->
    name[0].toLowerCase() + name.split(" ")[1].toLowerCase() + "@pinch.me"

  robot.respond /wishlist breakdown/i, (msg) ->
    msg.send "Let me fetch the data..."
    pm_url = pm_base_url + "jacques/wishlist_breakdown?access_token=" + pm_access_token

    msg.http(pm_url)
      .get() (err, res, body) ->
        json = JSON.parse(body)
        res = json.res

        msg.send "Got it! An email should arrive shortly."
        content = "<p>Here is the wishlist breakdown.</p>"
        subject = "Wishlist breakdown"
        success = emailThis(content, subject, msg.message.user.name, res)
        if success == 1
          msg.send "Email sent!"
          return

  robot.respond /users promo (.+)/i, (msg) ->
    if msg.match[1] != "17" && msg.match[1] != "9"
      msg.send "Nope. It works only with 9 and 17 for now!"
      return
    msg.send "Let me fetch the data..."
    pm_url = pm_base_url + "jacques/users_promo?access_token=" + pm_access_token + "&promo_id=" + msg.match[1]

    msg.http(pm_url)
      .get() (err, res, body) ->
        json = JSON.parse(body)
        res = json.res
        msg.send "Got it! An email should arrive shortly."
        content = "<p>Here are the users who ordered promo #{msg.match[1]}.</p>"
        subject = "Users promo #{msg.match[1]}"
        success = emailThis(content, subject, msg.message.user.name, res)
        if success == 1
          msg.send "Email sent!"
          return

  robot.respond /current users/i, (msg) ->
    pm_url = pm_base_url + "jacques/current_users?access_token=" + pm_access_token
    msg.send "Let me count..."
    msg.send "1... 2..."
    msg.http(pm_url)
      .get() (err, res, body) ->
        json = JSON.parse(body)
        res = json.res

        msg.send "There are #{numberWithCommas(res)} pinchers on the site."

  robot.respond /advanced profile stats/i, (msg) ->
    msg.send "Let me fetch the data..."
    pm_url = pm_base_url + "jacques/advanced_profile_stats?access_token=" + pm_access_token

    msg.http(pm_url)
      .get() (err, res, body) ->
        json = JSON.parse(body)
        file = json.file

        msg.send "Got it! An email should arrive shortly."
        content = json.content.replace(/\n/g, "<br/>").replace(/",/g, "\": ").replace(/"/g, "")
        subject = "Advanced profile stats"
        success = emailThis(content, subject, msg.message.user.name, file)
        if success == 1
          msg.send "Email sent!"
          return
