function getChars(str) {  
    var i = 0;  
    var c = 0.0;  
    var unicode = 0;  
    var len = 0;  
  
    if (str == null || str == "") {  
        return 0;  
    }  
    len = str.length;  
    for(i = 0; i < len; i++) {  
            unicode = str.charCodeAt(i);  
        if (unicode < 127) { //判断是单字符还是双字符  
            c += 1;  
        } else {  //chinese  
            c += 5;  
        }  
    }  
    return c;  
}  
  
function unicode_length(str) {  
    return getChars(str);  
}  
//截取字符  
function unicode_substring(str, startp, endp) {  
    var i=0; c = 0; unicode=0; rstr = '';  
    var len = str.length;  
    var sblen = unicode_length(str);  
  
    if (startp < 0) {  
        startp = sblen + startp;  
    }  
  
    if (endp < 1) {  
        endp = sblen + endp;// - ((str.charCodeAt(len-1) < 127) ? 1 : 2);  
    }  
    // 寻找起点  
    for(i = 0; i < len; i++) {  
        if (c >= startp) {  
            break;  
        }  
        var unicode = str.charCodeAt(i);  
        if (unicode < 127) {  
            c += 1;  
        } else {  
            c += 5;  
        }  
    }  
  
    // 开始取  
    for(i = i; i < len; i++) {  
        var unicode = str.charCodeAt(i);  
        if (unicode < 127) {  
            c += 1;  
        } else {  
            c += 5;  
        }  
        rstr += str.charAt(i);  
  
        if (c >= endp) {  
            break;  
        }  
    }  
  
    return rstr;  
}  

module.exports.unicode_length = unicode_length;
module.exports.unicode_substring = unicode_substring;
