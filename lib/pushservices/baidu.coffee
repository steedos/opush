BCM = require 'baidu-push-sdk'

class PushServiceBaidu
  tokenFormat: /^[0-9_]+$/
  validateToken: (token) ->
    @logger.info "token: " + token
    if PushServiceBaidu::tokenFormat.test(token)
      return token.toLowerCase()

  constructor: (conf, @logger, tokenResolver) ->
    @logger.verbose "api_key: " + conf.api_key
    @logger.verbose "secret_key: " + conf.secret_key
    opt =
      ak: conf.api_key
      sk: conf.secret_key

    @bcm = new BCM(opt)

  push: (subscriber, subOptions, payload) ->
    # token的格式: channelId + "_" + userId
    # info {"proto":"baidu|otask","token":"4421797412868072244_1021458100439220363","updated":1405307999,"created":1405072050}
    subscriber.get (info) =>
      @logger.info "Baidu push: " + JSON.stringify(info)

      messageCallback = (err, result) =>
        @logger.verbose "Baidu push message callback: " + err
        @logger.verbose "Baidu push message callback: " + JSON.stringify(result)

      notifCallback = (err, result) =>
        @logger.verbose "Baidu push notification callback: " + err
        @logger.verbose "Baidu push notification callback: " + JSON.stringify(result)

      ts = info.token.split("_")
      now = new Date
      now = now.getTime() + ""
      # 标题
      tle = payload.title.default || ""
      # 内容
      msg = payload.msg.default || ""
      # 去掉换行符
      msg = msg.replace(/\n/g, "")

      @logger.info "Baidu push title: " + tle
      @logger.info "Baidu push description: " + msg
      @logger.info "Baidu push badge: " + payload.badge

      # 发送推送消息
      @bcm.pushMsg({
        push_type: 1,
        device_type: 4,
        user_id: ts[1],
        channel_id: ts[0],
        message_type: 0,
        msg_keys: JSON.stringify([now]),
        messages: JSON.stringify({
          description: msg,
          badge: payload.badge
        }),
      }, messageCallback)

      # 如果内容和标题都存在时，发送通知
      if (msg != "" && tle != "")
        @bcm.pushMsg({
          push_type: 1,
          device_type: 4,
          user_id: ts[1],
          channel_id: ts[0],
          message_type: 1,
          msg_keys: JSON.stringify([now]),
          messages: JSON.stringify({
            title: tle,
            description: msg,
            notification_basic_style: 7,
            open_type: 2,
            custom_content: {
              badge: payload.badge
            }
          })
        }, notifCallback)

exports.PushServiceBaidu = PushServiceBaidu