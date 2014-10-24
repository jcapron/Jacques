module.exports = (robot) ->
  robot.respond /last (facebook|fb)/i, (msg) ->
    robot.http("https://www.facebook.com/PINCHme")
      .get() (err, res, body) ->
        matches = body.match /<a class="_5kjp uiLinkSubtle" href="(.+)"><abbr title=/i

        if matches and matches[1]
          res = matches[1].split "\"><abbr", 1
          if res[0][0] is "/"
            msg.send "https://www.facebook.com" + res
          else
            msg.send res
        else
          msg.send "No facebook posts right now"


  robot.respond /last (twitter|tweet)/i, (msg) ->
    robot.http("https://twitter.com/hashtag/pinchermoments?f=realtime")
      .get() (err, res, body) ->
        matches = body.match /<a href="(.+)" class="tweet-timestamp/i

        if matches and matches[1]
          msg.send "https://www.twitter.com" + matches[1]
        else
          msg.send "No tweets right now"
