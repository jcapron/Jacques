# Description:
#   Hans?
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   Hans? - Gives a random Hans gif

hanses = [  "http://media.tumblr.com/tumblr_le0zo9IfWm1qcig1w.gif",
            "http://26.media.tumblr.com/tumblr_lwtb64vrVf1qdau9mo1_500.gif",
            "http://31.media.tumblr.com/2b72036314b70894ab53ef68661ee51a/tumblr_myo758p6Wo1qcga5ro1_500.gif",
            "http://images5.fanpop.com/image/photos/26400000/Hans-Smiles-hans-gruber-26425003-400-282.gif",
            "http://media.tumblr.com/tumblr_le0q8guLY21qcig1w.gif",
            "https://33.media.tumblr.com/c813417610136fbcf56a48980cbd6d27/tumblr_mes6o4oYiR1qlhck1o1_500.gif",
            "http://big.assets.huffingtonpost.com/criminal.gif",
            "http://38.media.tumblr.com/fca5d3b619dee3a8c07524114ed8b6e9/tumblr_n43l07QcAu1qcra4yo8_250.gif",
            "http://38.media.tumblr.com/tumblr_mda78xX19T1qlhck1o1_r1_250.gif",
            "http://catchtwentydu.files.wordpress.com/2014/07/hans.gif?w=540" ]

module.exports = (robot) ->
  robot.hear /hans/i, (msg) ->
    msg.send msg.random hanses
