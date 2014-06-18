http = require 'http'
url = require 'url'

class PushServiceWEB
    validateToken: (token) ->
        return token

    constructor: (@conf, @logger, tokenResolver) ->

    push: (subscriber, subOptions, payload) ->



exports.PushServiceWEB = PushServiceWEB