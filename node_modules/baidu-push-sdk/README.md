BaiduPushNodejsServerSDK 
百度推送node.js接口
========================
感谢xiariqingquan，在其基础上补充了高级API接口和文档

# 安装 #

	npm install baidu-push-sdk
	npm install https://github.com/wangzheng422/BaiduPushNodejsServerSDK/tarball/master

# 基础API #

## 1.queryBindList ##

**功能：**查询设备、应用、用户与百度Channel的绑定关系。

**函数：**

    queryBindList(opt, callback)

**参数:**

  **opt**  Object , 属性如下表：
<table>
  <tr><th>参数名称</th><th>类型</th><th>是否必需</th><th>描述</th></tr>
  <tr><td>user_id</td><td>string</td><td>否</td><td>用户标识，不超过256字节</td></tr>
  <tr><td>start</td><td>uint</td><td>否</td><td>查询起始页码，默认为0。</td></tr>
  <tr><td>limit</td><td>uint</td><td>否</td><td>一次查询条数，默认为10。</td></tr>
  <tr><td>device_type</td><td>uint</td><td>否</td><td>设备的类型，</br>
3：Andriod设备；</br>
4：iOS设备；</br>
如果存在此字段，则只返回该设备类型的绑定关系。 默认不区分设备类型。
</td></tr>
</table>

**callback** 回调函数，其中参数
<table>
  <tr><th>参数名称</th><th>类型</th><th>描述</th></tr>
  <tr><td>err</td><td>Object</td><td>错误码，成功时返回null；失败时，抛出Error对象</td></tr>
  <tr><td>result</td><td>Object</td><td>返回值</td></tr>
</table>	

result包含response_params，response_params属性是一个二级json，由n个包含key和value属性的对象组成。表示API返回的数据内容。	

response_params中包含以下字段：
<table>
  <tr><th>字段</th><th>类型</th><th>描述</th></tr>
  <tr><td>total_num</td><td>uint</td><td>系统返回的消息个数。</td></tr>
  <tr><td>amount</td><td>uint</td><td>本次查询绑定数量。</td></tr>
  <tr><td>channel_id</td><td>uint</td><td>通道标识。</td></tr>
  <tr><td>user_id</td><td>string</td><td>channel绑定的user标识。</td></tr>
  <tr><td>device_id</td><td>uint</td><td>channel绑定的设备编号。</td></tr>
  <tr><td>device_type</td><td>uint</td><td>channel绑定的设备类型。</td></tr>
  <tr><td>device_name</td><td>string</td><td>channel绑定的设备描述。</td></tr>
  <tr><td>bind_name</td><td>string</td><td>channel绑定名称。</td></tr>
  <tr><td>bind_time</td><td>string</td><td>channel绑定时间。</td></tr>
  <tr><td>info</td><td>string</td><td>channel绑定附加信息。</td></tr>
  <tr><td>device_type</td><td>uint</td><td>channel绑定的设备类型。</td></tr>
  <tr><td>bind_status</td><td>uint</td><td>绑定状态，0：绑定在线； 1：绑定离线。</td></tr>
  <tr><td>online_status</td><td>string</td><td>应用在线状态，on:在线；off:离线。</td></tr>
  <tr><td>online_timestamp</td><td>uint</td><td>连接创建时间，仅在在线状态时返回。</td></tr>
  <tr><td>online_expires</td><td>uint</td><td>连接超时时，仅在在线状态时返回。</td></tr>
</table>
</table>


## 2.pushMsg ##

**功能：**推送消息，该接口可用于推送单个人、一群人、所有人以及固定设备的使用场景。

**函数：**

    pushMsg(opt, callback)

**参数:**

  **opt**  Object , 属性如下表：
 
<table>
  <tr><th>参数名称</th><th>类型</th><th>是否必需</th><th>描述</th></tr>
  <tr><td>user_id</td><td>string</td><td>否</td><td>用户标识，在Android里，channel_id + userid指定某一个特定client。不超过256字节，如果存在此字段，则只推送给此用户。</td></tr>
  <tr><td>push_type</td><td>uint</td><td>是</td><td>推送类型，取值范围为：1～3；</br>
1：单个人，必须指定user_id 和 channel_id （指定用户的指定设备）或者user_id（指定用户的所有设备）</br>
2：一群人，必须指定 tag</br>
3：所有人，无需指定tag、user_id、channel_id</td></tr>
  <tr><td>channel_id</td><td>uint</td><td>否</td><td>通道标识</td></tr>
  <tr><td>tag</td><td>string</td><td>否</td><td>标签名称，不超过128字节</td></tr>
  <tr><td>device_type</td><td>uint</td><td>否</td><td>设备类型，</br>3：Andriod设备；</br>4：iOS设备；</br>如果存在此字段，则向指定的设备类型推送消息。 默认为android设备类型。	</td></tr>
  <tr><td>message_type</td><td>uint</td><td>否</td><td>消息类型</br>
0：消息（透传给应用的消息体）</br>
1：通知（对应设备上的消息通知）
默认值为0。</td></tr>
  <tr><td>messages</td><td>string</td><td>是</td><td>指定消息内容，单个消息为单独字符串。如果有二进制的消息内容，请先做 BASE64 的编码。
当message_type为1 （通知类型），请按以下格式指定消息内容。</br>
通知消息格式及默认值：</br>

{</br>
//android必选，ios可选</br>
"title" : "hello" ,   </br>
“description: "hello world" </br>
</br>
//android特有字段，可选</br>
"notification_builder_id": 0,</br>
"notification_basic_style": 7,</br>
"open_type":0,</br>
"net_support" : 1,</br>
"user_confirm": 0,</br>
"url": "http://developer.baidu.com",</br>
"pkg_content":"",</br>
"pkg_name" : "com.baidu.bccsclient",</br>
"pkg_version":"0.1",</br>
</br>
//android自定义字段</br>
"custom_content": {    </br>
	"key1":"value1",    </br>
	"key2":"value2"     </br>
	},  </br>
</br>
//ios特有字段，可选</br>
"aps": {</br>
	"alert":"Message From Baidu Push",</br>
	"Sound":"",</br>
	"Badge":0</br>
	},</br>
</br>
//ios的自定义字段</br>
"key1":"value1", </br>
"key2":"value2"</br>
}</br>
注意：</br>
当description与alert同时存在时，ios推送以alert内容作为通知内容</br>
当custom_content与 ios的自定义字段"key":"value"同时存在时，ios推送的自定义字段内容会将以上两个内容合并，但推送内容整体长度不能大于256B，否则有被截断的风险。</br>
此格式兼容Android和ios原生通知格式的推送。</br>
</td></tr>
  <tr><td>msg_keys</td><td>string</td><td>是</td><td>消息标识。
指定消息标识，必须和messages一一对应。相同消息标识的消息会自动覆盖。特别提醒：该功能只支持android设备。</td></tr>
  <tr><td>message_expires</td><td>uint</td><td>否</td><td>指定消息的过期时间，默认为86400秒。必须和messages一一对应。</td></tr>
  <tr><td>deploy_status</td><td>uint</td><td>否</td><td>部署状态。指定应用当前的部署状态，可取值：</br>
1：开发状态</br>
2：生产状态</br>
若不指定，则默认设置为生产状态。特别提醒：该功能只支持ios设备类型。</td></tr>
</table>

**callback** 回调函数，其中参数
<table>
  <tr><th>参数名称</th><th>类型</th><th>描述</th></tr>
  <tr><td>err</td><td>Object</td><td>错误码，成功时返回null；失败时，抛出Error对象</td></tr>
  <tr><td>result</td><td>Object</td><td>返回值</td></tr>
</table>	



示例

	var baidu_push = require("baidu-push-sdk");
	
	var client = new baidu_push({
		ak: 'your ak here',
		sk: 'your sk here'
	});
	
	client.pushMsg({
		user_id:"your user id here",
		channel_id:"your channel id here",
		push_type: 1,
		device_type:4,
		messages: JSON.stringify({title:'title',description:'description',aps:{alert:'aps message',sound:'',badge:0}}),
		msg_keys: JSON.stringify(["key0"]),
		message_type:1,
		deploy_status:1
	}, function(err, result){
		console.log(result);
	})
			
# 高级API #

## 3.verifyBind ##

**功能：**判断设备、应用、用户与Channel的绑定关系是否存在。

**函数：**

    verifyBind(opt, callback)

**参数:**

  **opt**  Object , 属性如下表：
<table>
  <tr><th>参数名称</th><th>类型</th><th>是否必需</th><th>描述</th></tr>
  <tr><td>user_id</td><td>string</td><td>是</td><td>用户标识，不超过256字节</td></tr>
  <tr><td>device_type</td><td>string</td><td>否</td><td>设备的类型编号如下：</br>
3：Andriod设备；</br>
4：iOS设备；</br>
如果存在此字段，则只返回该设备类型的绑定关系。 默认不区分设备类型。</td></tr>
</table>
**callback** 回调函数，其中参数
<table>
  <tr><th>参数名称</th><th>类型</th><th>描述</th></tr>
  <tr><td>err</td><td>Object</td><td>错误码，成功时返回null；失败时，抛出Error对象</td></tr>
  <tr><td>result</td><td>Object</td><td>返回值</td></tr>
</table>			

## 4.fetchMsg ##

**功能：**查询离线消息。

**函数：**

    fetchMsg(opt, callback)

**参数:**

  **opt**  Object , 属性如下表：
<table>
  <tr><th>参数名称</th><th>类型</th><th>是否必需</th><th>描述</th></tr>
  <tr><td>user_id</td><td>string</td><td>是</td><td>用户标识，不超过256字节</td></tr>
  <tr><td>start</td><td>uint</td><td>否</td><td>查询起始页码，默认为0。</td></tr>
  <tr><td>limit</td><td>uint</td><td>否</td><td>一次查询条数，默认为10。</td></tr>
</table>
**callback** 回调函数，其中参数
<table>
  <tr><th>参数名称</th><th>类型</th><th>描述</th></tr>
  <tr><td>err</td><td>Object</td><td>错误码，成功时返回null；失败时，抛出Error对象</td></tr>
  <tr><td>result</td><td>Object</td><td>返回值</td></tr>
</table>

result包含response_params，response_params属性是一个二级json，由n个包含key和value属性的对象组成。表示API返回的数据内容。	

response_params中包含以下字段：
<table>
  <tr><th>字段</th><th>类型</th><th>描述</th></tr>
  <tr><td>total_num</td><td>uint</td><td>系统返回的消息个数。</td></tr>
  <tr><td>channel_id</td><td>uint</td><td>通道标识。</td></tr>
  <tr><td>msg_id</td><td>uint</td><td>系统返回的消息id。</td></tr>
  <tr><td>msg_key</td><td>string</td><td>消息标识，用于覆盖消息内容。</td></tr>
  <tr><td>message</td><td>string</td><td>消息内容。</td></tr>
  <tr><td>mssage_length</td><td>uint</td><td>系统返回的消息长度。</td></tr>
  <tr><td>message_type</td><td>uint</td><td>消息类型。</td></tr>
  <tr><td>message_expires</td><td>uint</td><td>消息过期时间。</td></tr>
</table>


## 5.fetchMsgCount ##

**功能：**查询离线消息的个数。

**函数：**

    fetchMsgCount(opt, callback)

**参数:**

  **opt**  Object , 属性如下表：
<table>
  <tr><th>参数名称</th><th>类型</th><th>是否必需</th><th>描述</th></tr>
  <tr><td>user_id</td><td>string</td><td>是</td><td>用户标识，不超过256字节</td></tr>
</table>
**callback** 回调函数，其中参数
<table>
  <tr><th>参数名称</th><th>类型</th><th>描述</th></tr>
  <tr><td>err</td><td>Object</td><td>错误码，成功时返回null；失败时，抛出Error对象</td></tr>
  <tr><td>result</td><td>Object</td><td>返回值</td></tr>
</table>	

result包含response_params，response_params属性是一个二级json，由n个包含key和value属性的对象组成。表示API返回的数据内容。	

response_params中包含以下字段：
<table>
  <tr><th>字段</th><th>类型</th><th>描述</th></tr>
  <tr><td>total_num</td><td>uint</td><td>系统返回的消息总数。</td></tr>
</table>


## 6.deleteMsg ##

**功能：**删除离线消息。

**函数：**

    deleteMsg(opt, callback)

**参数:**

  **opt**  Object , 属性如下表：
<table>
  <tr><th>参数名称</th><th>类型</th><th>是否必需</th><th>描述</th></tr>
  <tr><td>user_id</td><td>string</td><td>是</td><td>用户标识，不超过256字节</td></tr>
  <tr><td>msg_ids</td><td>string</td><td>是</td><td>删除的消息id列表，由一个或多个msg_id组成，多个用json数组表示。如：123 或 [123, 456]。</td></tr>
</table>
**callback** 回调函数，其中参数
<table>
  <tr><th>参数名称</th><th>类型</th><th>描述</th></tr>
  <tr><td>err</td><td>Object</td><td>错误码，成功时返回null；失败时，抛出Error对象</td></tr>
  <tr><td>result</td><td>Object</td><td>返回值</td></tr>
</table>	

result包含response_params，response_params属性是一个二级json，由n个包含key和value属性的对象组成。表示API返回的数据内容。	

response_params中包含以下字段：
<table>
  <tr><th>字段</th><th>类型</th><th>描述</th></tr>
  <tr><td>success_amount</td><td>uint</td><td>成功删除条数。</td></tr>
  <tr><td>msg_id</td><td>uint</td><td>删除消息ID。</td></tr>
  <tr><td>result</td><td>uint</td><td>消息删除结果，有以下两个值：
0：成功；

1：失败。</td></tr>
</table>


## 7.setTag ##

**功能：**服务器端设置用户标签。当该标签不存在时，服务端将会创建该标签。特别地，当user_id被提交时，服务端将会完成用户和tag的绑定操作。

**函数：**

    setTag(opt, callback)

**参数:**

  **opt**  Object , 属性如下表：
<table>
  <tr><th>参数名称</th><th>类型</th><th>是否必需</th><th>描述</th></tr>
  <tr><td>user_id</td><td>string</td><td>否</td><td>用户标识，不超过256字节</td></tr>
  <tr><td>tag</td><td>string</td><td>是</td><td>标签名，最长128字节。</td></tr>
</table>
**callback** 回调函数，其中参数
<table>
  <tr><th>参数名称</th><th>类型</th><th>描述</th></tr>
  <tr><td>err</td><td>Object</td><td>错误码，成功时返回null；失败时，抛出Error对象</td></tr>
  <tr><td>result</td><td>Object</td><td>返回值</td></tr>
</table>


## 8.fetchTag ##

**功能：**App Server查询应用标签。

**函数：**

    fetchTag(opt, callback)

**参数:**

  **opt**  Object , 属性如下表：
<table>
  <tr><th>参数名称</th><th>类型</th><th>是否必需</th><th>描述</th></tr>
  <tr><td>name</td><td>string</td><td>否</td><td>标签名称。</td></tr>
  <tr><td>start</td><td>uint</td><td>否</td><td>查询起始页码，默认为0。</td></tr>
  <tr><td>limit</td><td>uint</td><td>否</td><td>一次查询条数，默认为10。</td></tr>
</table>
>**说明**：name若被指定，则获取该标签的详细信息；否则，获取按页获取应用的所有标签。

**callback** 回调函数，其中参数
<table>
  <tr><th>参数名称</th><th>类型</th><th>描述</th></tr>
  <tr><td>err</td><td>Object</td><td>错误码，成功时返回null；失败时，抛出Error对象</td></tr>
  <tr><td>result</td><td>Object</td><td>返回值</td></tr>
</table>	

result包含response_params，response_params属性是一个二级json，由n个包含key和value属性的对象组成。表示API返回的数据内容。	

response_params中包含以下字段：
<table>
  <tr><th>字段</th><th>类型</th><th>描述</th></tr>
  <tr><td>total_num</td><td>uint</td><td>系统返回的消息总数。</td></tr>
  <tr><td>amount</td><td>uint</td><td>本次查询绑定数量。</td></tr>
  <tr><td>tags</td><td>string</td><td>标签数组，其中包含：</br>
tid：标签ID </br>
name：标签名称</br>
info：标签信息</br>
type：标签类型</br>
create_time：标签创建时间</td></tr>
</table>


## 9.deleteTag ##

**功能：**服务端删除用户标签。特别地，当user_id被提交时，服务端将只会完成解除该用户与tag绑定关系的操作。
>注意：该操作不可恢复，请谨慎使用。

**函数：**

    deleteTag(opt, callback)

**参数:**

  **opt**  Object , 属性如下表：
<table>
  <tr><th>参数名称</th><th>类型</th><th>是否必需</th><th>描述</th></tr>
  <tr><td>user_id</td><td>string</td><td>否</td><td>用户标识，不超过256字节</td></tr>
  <tr><td>tag</td><td>string</td><td>是</td><td>标签名，最长128字节。</td></tr>
</table>

**callback** 回调函数，其中参数
<table>
  <tr><th>参数名称</th><th>类型</th><th>描述</th></tr>
  <tr><td>err</td><td>Object</td><td>错误码，成功时返回null；失败时，抛出Error对象</td></tr>
  <tr><td>result</td><td>Object</td><td>返回值</td></tr>
</table>	


## 10.queryUserTag ##

**功能：**App Server查询用户所属的标签列表。

**函数：**

    queryUserTag(opt, callback)

**参数:**

  **opt**  Object , 属性如下表：
<table>
  <tr><th>参数名称</th><th>类型</th><th>是否必需</th><th>描述</th></tr>
  <tr><td>user_id</td><td>string</td><td>是</td><td>用户标识，不超过256字节</td></tr>
</table>

**callback** 回调函数，其中参数
<table>
  <tr><th>参数名称</th><th>类型</th><th>描述</th></tr>
  <tr><td>err</td><td>Object</td><td>错误码，成功时返回null；失败时，抛出Error对象</td></tr>
  <tr><td>result</td><td>Object</td><td>返回值</td></tr>
</table>	

result包含response_params，response_params属性是一个二级json，由n个包含key和value属性的对象组成。表示API返回的数据内容。	

response_params中包含以下字段：
<table>
  <tr><th>字段</th><th>类型</th><th>描述</th></tr>
  <tr><td>tag_num</td><td>uint</td><td>标签数</td></tr>
  <tr><td>tags</td><td>string</td><td>标签数组，其中包含：</br>
tid：标签ID</br>

name：标签名称</br>

info：标签信息</br>

type：标签类型</br>

create_time：标签创建时间</td></tr>
</table>



## 11.queryDeviceTag ##

**功能：**根据channel_id查询设备类型。

**函数：**

    queryDeviceTag(opt, callback)

**参数:**

  **opt**  Object , 属性如下表：
<table>
  <tr><th>参数名称</th><th>类型</th><th>是否必需</th><th>描述</th></tr>
  <tr><td>channel_id</td><td>uint</td><td>是</td><td>通道标识，系统返回的channel_id。</td></tr>
</table>

**callback** 回调函数，其中参数
<table>
  <tr><th>参数名称</th><th>类型</th><th>描述</th></tr>
  <tr><td>err</td><td>Object</td><td>错误码，成功时返回null；失败时，抛出Error对象</td></tr>
  <tr><td>result</td><td>Object</td><td>返回值</td></tr>
</table>	

result包含response_params，response_params属性是一个二级json，由n个包含key和value属性的对象组成。表示API返回的数据内容。	

response_params中包含以下字段：
<table>
  <tr><th>字段</th><th>类型</th><th>描述</th></tr>
  <tr><td>device_type</td><td>uint</td><td>设备的类型，
3：Andriod设备；
4：iOS设备；
</td></tr>
</table>
