module.exports = (robot) ->
  robot.hear /team/i, (msg) ->
    msg.send "One team, one dream!"

  robot.hear /don't know|dunno/i, (msg) ->
    msg.send "http://cl.ly/YD3j/Neil%20deGrasse%20Tyson.gif"
