# Description:
#   Kanye's quotes!
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   kanye - Gives a random quote from Kanye
#
# Author:
#   jcapron

quotes = [  "Would you believe in what you believe in if you were the only one who believed it?",
            "I am God's vessel. But my greatest pain in life is that I will never be able to see myself perform live.",
            "I was never really good at anything except for the ability to learn.",
            "I feel like I'm too busy writing history to read it.",
            "If I was just a fan of music, I would think that I was the number one artist in the world.",
            "I don't even listen to rap. My apartment is too nice to listen to rap in.",
            "I still think I am the greatest." ]

module.exports = (robot) ->
  robot.hear /kanye/i, (msg) ->
    msg.send msg.random quotes
