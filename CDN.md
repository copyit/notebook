

## UPYUN

### FTP

人家支持用ftp传输文件，而且用ftp似乎不对流量计费

ftp://v0.ftp.upyun.com 

用户名是"操作员名/服务名"（其中/字符是用户名的一部分）,密码为"操作员密码"

### UpyunManager

http://micyin.b0.upaiyun.com/manager-for-upyun/manager-for-upyun-0.0.6-win32.exe


### curlftpfs

在这种情境下可靠性不高，不建议使用

http://curlftpfs.sourceforge.net/

注意命令中的 ftp://用户名:密码@v0.ftp.upyun.com 其中的用户名的/符号需要改为%2f

### python规则刷新

本代码作为EasyLogin项目的一个例子

[https://github.com/zjuchenyuan/EasyLogin/tree/master/examples/upyun](https://github.com/zjuchenyuan/EasyLogin/tree/master/examples/upyun)

### python调用API进行URL刷新

官方文档：http://docs.upyun.com/api/purge/

[我的代码upyun_purge.py](code/upyun_purge.py)

注意操作员要被授权，调用API正常的返回值就是`{'invalid_domain_of_url': {}}`，不要看到invalid就以为出错了hhh

### 使用upyun提供的webp功能节省流量

无需任何代码，只需要在原图后面加上`!/format/webp`即可，假设已经在使用自定义图片格式，例如`!compress`则变为`!compress/format/webp`可以进一步节省流量

官方说明：https://www.upyun.com/webp.html

### 使用边缘规则修复改版导致的404问题

本站原版使用的Jekyll将xxx.md编译为xxx.html，现在改用MkDocs后xxx.md编译得到的是xxx/index.html，原先的链接就404了

又拍云能配置边缘规则 进行URL改写，用户在访问xxx.html的时候实际回源xxx/

而且配置挺简单，只要会写正则即可

配置规则如下：

条件判断： 如果请求URI 正则匹配 `^/[^/]*html$`
功能选择： URL改写
    URI 字符串提取： `^/([^/]*).html$`
    改写规则：`/$1/`
break: 打勾
----

### 使用边缘规则实现upyun TOKEN反盗链功能

想只对特定url使用token反盗链，于是就使用边缘规则来实现一下完全兼容反盗链的算法咯

发现一个坑：又拍云的边缘规则的`$SUB`函数 其from和to是从1开始计数的，包括from，也包括to

URI 字符串提取不填，break不选，规则编辑器填以下内容

```
$WHEN($MATCH($_URI, '这里填URI匹配正则'),$OR($GT($_TIME, $SUB($_GET__upt, 9,99)),$NOT($_GET__upt), $NOT($EQ($SUB($MD5('这里填TOKEN''&'$SUB($_GET__upt, 9,99)'&'$_URI),13,20),$SUB($_GET__upt, 1,8)))))$EXIT(403)
```

## Qiniu

### 使用qshell上传文件夹

    qshell qupload [<ThreadCount>] <LocalUploadConfig>

需要写一个config文件，具体参见官方文档

[http://developer.qiniu.com/code/v6/tool/qshell.html](http://developer.qiniu.com/code/v6/tool/qshell.html)

[https://github.com/qiniu/qshell/wiki/qupload](https://github.com/qiniu/qshell/wiki/qupload)