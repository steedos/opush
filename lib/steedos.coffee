async = require 'async'
util = require 'util'
logger = require 'winston'

uuid = require './uuid'


exports.setup  = (app, createSubscriber, getEventFromId, authorize, testSubscriber, eventPublisher, getSubscriberFromId) ->
    authorize ?= (realm) ->


    app.post '/getState', authorize('register'), (req, res) ->

        logger.verbose "getState: " + JSON.stringify(req.body)
        try
            states = []
            if req.body.pushTopics?
                events = {}
                c = 0
                for topic in req.body.pushTopics
                    events[topic] = {}
                    events[topic].pushTopic = topic
                    events[topic].data = {}
                    event = getEventFromId(topic)
                    event.info (info, name) ->
                        if info?
                            logger.verbose "getState, event info: " + name + "," + JSON.stringify(info)
                            logger.verbose "getState, event: " + JSON.stringify(events[name])
                            events[name].data.badge = info.badge
                            states.push(events[name])
                        c = c + 1
                        if (c >= req.body.pushTopics.length)
                            res.json {states: states}, 200

        catch error
            logger.error "Creating token failed: #{error.message}"
            res.json error: error.message, 400

    app.post '/getToken', authorize('register'), (req, res) ->

        logger.verbose "getToken: " + JSON.stringify(req.body)
        try
            fields = {}
            fields.proto = "web"
            fields.token = uuid()
            createSubscriber fields, (subscriber, created) ->
                subscriber.get (info) ->
                    info.id = subscriber.id
                    if req.body.pushTopics?
                        events = {};
                        for topic in req.body.pushTopics
                            events[topic] = {}
                        subscriber.addSubscriptions(events)

                    res.header 'Location', "/getToken/#{subscriber.id}"
                    res.json {}, if created then 201 else 200

        catch error
            logger.error "Creating token failed: #{error.message}"
            res.json error: error.message, 400


    app.post '/registerTopics', authorize('register'), (req, res) ->

        logger.verbose "registerTopics: " + JSON.stringify(req.body)
        try
            if req.body.pushToken?
                req.subscriber = getSubscriberFromId(req.body.pushToken)
            else
                throw new Error("pushToken not found")

            if req.body.pushTopics?
                events = {};
                for topic in req.body.pushTopics
                    events[topic] = {}
                req.subscriber.addSubscriptions(events)
                
            res.header 'Location', "/getToken/#{req.subscriber.id}"
            res.json {}, 201

        catch error
            logger.error "registerTopics failed: #{error.message}"
            res.json error: error.message, 400


    app.post '/unregisterTopics', authorize('register'), (req, res) ->

        logger.verbose "unregisterTopics: " + JSON.stringify(req.body)
        try
            if req.body.pushToken?
                req.subscriber = getSubscriberFromId(req.body.pushToken)
            else
                throw new Error("pushToken not found")

            if req.body.pushTopics?
                events = {};
                for topic in req.body.pushTopics
                    events[topic] = {}
                req.subscriber.removeSubscriptions(events)
                
            res.header 'Location', "/getToken/#{req.subscriber.id}"
            res.json {}, 201

        catch error
            logger.error "registerTopics failed: #{error.message}"
            res.json error: error.message, 400


    # Get token info
    app.get '/getToken/:subscriber_id', authorize('listen'), (req, res) ->
        req.subscriber.getSubscriptions (subs) ->
            if subs?
                result = {}
                result.pushToken = req.subscriber.id
                result.pushTokenTTL = 6000
                result.registeredTopics = []

                for sub in subs
                    result.registeredTopics.push(sub.event.name)

                result.webCourierURL = "/webcourier"
                res.json result, if result? then 200 else 404
            else
                logger.error "No subscriber #{req.subscriber.id}"
                res.send 404


    app.get '/webcourior', authorize('listen'), (req, res) ->

        unless typeof req.query.events is 'string'
            res.send 400
            return

        eventNames = req.query.events.split ' '

        req.socket.setTimeout(Infinity);
        req.socket.setNoDelay(true);
        res.set
            'Content-Type': 'text/event-plain',
            'Cache-Control': 'no-cache',
            'Access-Control-Allow-Origin': '*',
        res.write('\n')

        if req.get('User-Agent')?.indexOf('MSIE') != -1
            # Work around MSIE bug preventing Progress handler from behing thrown before first 2048 bytes
            # See http://forums.adobe.com/message/478731
            res.write new Array(2048).join('\n')

        sendEvent = (event, payload) ->
            data =
                event: event.name
                title: payload.title
                message: payload.msg
                data: payload.data

            res.write(JSON.stringify(data))
            res.end()

        antiIdleInterval = setInterval ->
            res.write "\n"
        , 10000

        res.socket.on 'close', =>
            clearInterval antiIdleInterval
            for eventName in eventNames
                eventPublisher.removeListener eventName, sendEvent

        for eventName in eventNames
            eventPublisher.addListener eventName, sendEvent