# Description:
#   Gets a random developer, designer and manager excuses
#
# Commands:
#   hubot excuse me|developer excuse - Gives a developer excuse
#   hubot designer excuse - Gives a designer excuse
#   hubot manager excuse - Gives a manager excuse

DESIGNER_EXCUSES = [
  "That won't fit the grid.",
  "That's not in the wireframes.",
  "That's a developer thing.",
  "I didn't mock it up that way.",
  "The developer must have changed it.",
  "Did you try hitting refresh?",
  "No one uses IE anyway.",
  "That's not how I designed it.",
  "That's way too skeuomorphic.",
  "That's way too flat.",
  "Just put a long shadow on it.",
  "It wasn't designed for that kind of content.",
  "Josef Müller-Brockmann.",
  "That must be a server thing.",
  "It only looks bad if it's not on Retina.",
  "Are you looking at it in IE or something?",
  "That's not a recognised design pattern.",
  "It wasn't designed to work with this content.",
  "The users will never notice that.",
  "The users might not notice it, but they'll feel it.",
  "These brand guidelines are shit.",
  "You wouldn't get it, it's a design thing.",
  "Jony wouldn't do it like this.",
  "That's a dark pattern.",
  "I don't think that's very user friendly.",
  "That's not what the research says.",
  "I didn't get a change request for that."
]

module.exports = (robot) ->
  robot.respond /excuse me|\bdeveloper excuse\b/i, (msg) ->
    robot.http("http://developerexcuses.com")
      .get() (err, res, body) ->
        matches = body.match /<a [^>]+>(.+)<\/a>/i

        if matches and matches[1]
          msg.send matches[1]
        else
          msg.send "I thought I finished that"

  robot.respond /\bdesigner excuse\b/i, (msg) ->
    msg.send msg.random(DESIGNER_EXCUSES)

  robot.respond /\bmanager excuse\b/i, (msg) ->
    robot.http("http://accountmanagerexcuses.com/")
      .get() (err, res, body) ->
        matches = body.match /<a [^>]+>(.+)<\/a>/i

        if matches and matches[1]
          msg.send matches[1]
        else
          msg.send "I thought I finished that"
