module.exports = (robot) ->
  robot.hear /team/i, (msg) ->
    msg.send "One team, one dream!"

  robot.hear /^I don't know$|^I dunno$/i, (msg) ->
    msg.send "http://cl.ly/YD3j/Neil%20deGrasse%20Tyson.gif"
