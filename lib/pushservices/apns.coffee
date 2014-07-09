apns = require 'apn'
logger = require 'winston'

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
               note.alert = "[" + note.alert + "] " + message
            note.badge = badge if not isNaN(badge = parseInt(payload.badge))
            note.sound = payload.sound
            if @payloadFilter?
                for key, val of payload.data
                    note.payload[key] = val if key in @payloadFilter
            else
                note.payload = payload.data


            
            note_bytesize = JSON.stringify(note).replace(/[^\x00-\xff]/gi, "--").length
            alert = note.alert
            oldAlert_bytesize = alert.replace(/[^\x00-\xff]/gi, "--").length
            if note_bytesize > 265
                difference = note_bytesize - 265
            alert_bytesize =  oldAlert_bytesize - difference - 3 
            alertNew = ''
            for(var i = 0; i < b.length;i++){
                alert(b.charAt(i));
                if alertNew.replace(/[^\x00-\xff]/gi, "--").length + b.charAt(i).replace(/[^\x00-\xff]/gi, "--").length <= alert_bytesize
                    alertNew = alertNew + b.charAt(i)
                else 
                    alertNew = alertNew + '...'
            }

            note.alert = alertNew

            logger.verbose "APNS push msg: " + JSON.stringify(note)
            @driver.pushNotification note, device
            # On iOS we have to maintain the badge counter on the server
            #subscriber.incr 'badge'

exports.PushServiceAPNS = PushServiceAPNS
