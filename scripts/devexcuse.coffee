# Description:
#   Dev excuses scraper. From http://developerexcuses.com/
#
# Dependencies:
#
#   "cheerio": "~0.12.0"
#
# Commands:
#   hubot excuse me

module.exports = (robot) ->
  robot.respond /excuse me/i, (msg) ->
    robot.http("http://developerexcuses.com")
      .get() (err, res, body) ->
        matches = body.match /<a [^>]+>(.+)<\/a>/i

        if matches and matches[1]
          msg.send matches[1]
        else
          msg.send "I thought I finished that"
