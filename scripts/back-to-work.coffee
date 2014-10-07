# Description:
#   Back to work!
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   None
#
# Author:
#   jmmorgan

THROTTLE_WINDOW_IN_MILLIS = 600000 # 10 minutes
THROTTLE_MESSAGE_LIMIT = 10

images = [  'http://identitymagazine.net/wp-content/uploads/2010/11/BACKTOWORKLOGO.jpg',
            'http://4.bp.blogspot.com/-gGVDiOqVXC8/UZJlPyFJg_I/AAAAAAAAJW0/54d9P85SGtw/s1600/BACKTOWORK2.jpg',
            'http://www.artesianspringom.com/wp-content/uploads/2014/01/back-to-work.jpg',
            'http://riddlerreviews.files.wordpress.com/2011/04/work.jpg',
            'http://lh4.ggpht.com/-6dcDh9eS9Ow/T0l3DPZ2YTI/AAAAAAAACb8/rYd9JWh5sIA/if%252520you%252520can%252520read%252520this_thumb%25255B1%25255D.jpg?imgmax=800',
            'http://blog.theregularguynyc.com/wp-content/uploads/2014/05/mr-t-time-meme-generator-get-back-to-work-fool-fc0cc7.jpg',
            'http://memetogo.com/media/created/qoa804.jpg',
            'http://makeameme.org/media/created/get-back-to-hvys0a.jpg',
            'http://www.quickmeme.com/img/92/92d811887351152e055e3e577d8a84595be75761e70383a3d7958449700a4c8a.jpg',
            'http://img.pandawhale.com/post-24407-Mr-T-quit-yo-surfin-get-back-t-T5a9.gif'
]

module.exports = (robot) ->
  robot.hear /.*/i, (msg) ->
    
    now = (new Date).getTime();
    windowStart = now - THROTTLE_WINDOW_IN_MILLIS
    @messageTimes ||= []
    @messageTimes.push now
    @recentMessageTimes = @messageTimes.filter (messageTime) -> messageTime > windowStart

    if (@recentMessageTimes.length >= THROTTLE_MESSAGE_LIMIT)
      msg.send 'Back to work!'
      msg.send msg.random images
      process.exit 0
