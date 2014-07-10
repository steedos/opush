apns = require 'apn'
logger = require 'winston'
unicode = require '../unicode'

class PushServiceAPNS
    tokenFormat: /^[0-9a-f]{64}$/i
    validateToken: (token) ->
        if PushServiceAPNS::tokenFormat.test(token)
            return token.toLowerCase()

    constructor: (conf, @logger, tokenResolver) ->
        conf.errorCallback = (errCode, note, device) =>
            @logger?.error("APNS Error #{errCode} for subscriber #{device?.subscriberId}")
        @driver = new apns.Connection(conf)

        @payloadFilter = conf.payloadFilter

        @feedback = new apns.Feedback(conf)
        # Handle Apple Feedbacks
        @feedback.on 'feedback', (feedbackData) =>
            feedbackData.forEach (item) =>
                tokenResolver 'apns', item.device.toString(), (subscriber) =>
                    subscriber?.get (info) ->
                        if info.updated < item.time
                            @logger?.warn("APNS Automatic unregistration for subscriber #{subscriber.id}")
                            subscriber.delete()


    push: (subscriber, subOptions, payload) ->
        subscriber.get (info) =>
            logger.verbose "APNS push: " + payload.msg.default + JSON.stringify(info)
            note = new apns.Notification()
            device = new apns.Device(info.token)
            device.subscriberId = subscriber.id # used for error logging
            note.alert = payload.localizedTitle(info.lang)
            if subOptions?.ignore_message isnt true and message = payload.localizedMessage(info.lang)
               note.alert = note.alert + "\n" + message
            note.badge = badge if not isNaN(badge = parseInt(payload.badge))
            note.sound = payload.sound if (payload.sound)
            if @payloadFilter?
                for key, val of payload.data
                    note.payload[key] = val if key in @payloadFilter
            else
                note.payload = payload.data

            
            note_bytesize = unicode.unicode_length(JSON.stringify(note))

            if note_bytesize > 255
                alert_bytesize = unicode.unicode_length(note.alert)
            
                difference = note_bytesize - 255
                alert_new_bytesize =  alert_bytesize - difference - 4

                note.alert = unicode.unicode_substring(note.alert, 0, alert_new_bytesize) + "..."

            logger.verbose "APNS push msg: " + JSON.stringify(note)
            @driver.pushNotification note, device
            # On iOS we have to maintain the badge counter on the server
            #subscriber.incr 'badge'

exports.PushServiceAPNS = PushServiceAPNS
