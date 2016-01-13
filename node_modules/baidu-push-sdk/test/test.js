
var id0 = '822808065592337373';     //user_id
var id1 = '4444772434926320147';    //channel_id

function queryBindList(client) {
  var opt = {
    user_id: id0
  }
  client.queryBindList(opt, function(err, result) {
    if (err) {
      console.log(err);
      return;
    }
    console.log(result);
  })
}

function pushMsg2Single(client) {
  var JsonMsg={"title" : "hello","description": "hello world" } ;

  var opt = {
    push_type: 1,
    user_id: id0,
    channel_id: id1,
    message_type:1,
      //可以一次推送一条或多条信息
      //一条
    //messages: JSON.stringify(JsonMsg),
    // msg_keys: JSON.stringify(["key0"])

      //多条
      messages: JSON.stringify([{"title" : "hello","description": "hello world" },{"title" : "hello2","description": "hello222 world" }]),
      msg_keys: JSON.stringify(["key0","key1"])
  }
  client.pushMsg(opt, function(err, result) {
    if (err) {
      console.log(err);
      return;
    }
    console.log(result);
  })
}


function pushMsgByTag(client) {
    var JsonMsg={"title" : "hello","description": "hello world" } ;

    var opt = {
        push_type: 2,
        tag:"nodeA0,nodeA1",
        message_type:1,
        messages: JSON.stringify(JsonMsg),
        msg_keys: JSON.stringify(["key4"])
    }
    client.pushMsg(opt, function(err, result) {
        if (err) {
            console.log(err);
            return;
        }
        console.log(result);
    })
}


function verifyBind(client){
    var opt = {
        device_type: 3,
        user_id: id0
    }
    client.verifyBind(opt, function(err, result) {
        if (err) {
            console.log(err);
            return;
        }
        console.log(result);
    })
}

function fetchMsg(client){
    var opt = {
        user_id: id0
    }
    client.fetchMsg(opt, function(err, result) {
        if (err) {
            console.log(err);
            return;
        }
        console.log(result);
    })
}

function fetchMsgCount(client){
    var opt = {
        user_id: id0
    }
    client.fetchMsgCount(opt, function(err, result) {
        if (err) {
            console.log(err);
            return;
        }
        console.log(result);
    })
}

function deleteMsg(client){
    var opt = {
        msg_ids: ['aisino'],
        user_id: id0
    }
    client.deleteMsg(opt, function(err, result) {
        if (err) {
            console.log(err);
            return;
        }
        console.log(result);
    })
}

function setTag(client){
    var opt = {
        tag: "nodeA0,nodeA1",
        user_id: id0
    }
    client.setTag(opt, function(err, result) {
        if (err) {
            console.log(err);
            return;
        }
        console.log(result);
    })
}

function fetchTag(client){
    var opt = {
    }
    client.fetchTag(opt, function(err, result) {
        if (err) {
            console.log(err);
            return;
        }
        console.log(result);
    })
}

function deleteTag(client){
    var opt = {
        tag: "nodeA0,nodeA1",
        user_id: id0
    }
    client.deleteTag(opt, function(err, result) {
        if (err) {
            console.log(err);
            return;
        }
        console.log(result);
    })
}

function queryUserTag(client){
    var opt = {
        user_id: id0
    }
    client.queryUserTag(opt, function(err, result) {
        if (err) {
            console.log(err);
            return;
        }
        console.log(result);
    })
}

function queryDeviceTag(client){
    var opt = {
        channel_id: id1
    }
    client.queryDeviceTag(opt, function(err, result) {
        if (err) {
            console.log(err);
            return;
        }
        console.log(result);
    })
}
var Push = require('../index');
(function() {
  var opt = {
   ak: 'your ak here ',
   sk: 'your sk here'

  };
  var client = new Push(opt);
   //queryBindList(client);
   // pushMsg2Single(client);
   //pushMsgByTag(client);
   //verifyBind(client);

   // fetchMsg(client);

    //setTag(client);
    //pushMsgByTag(client);
    //fetchTag(client);

    //queryUserTag(client);

    queryDeviceTag(client);
})()
