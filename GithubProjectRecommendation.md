

## you-get

https://github.com/soimort/you-get

pip安装后直接下载b站超清视频

本想自己用PhantomJS写bilibili的下载的，没想到人家拿到了签名的私钥，直接免浏览器实现了666

----

## Anki

https://github.com/dae/anki

Anki是一个辅助记忆软件，它可以在相对合适的时间来告诉你复习什么比较好。

Learn More:

https://zhuanlan.zhihu.com/p/21338255?refer=-anki

https://zhuanlan.zhihu.com/-anki

----

## OnlineJudge

https://github.com/QingdaoU/OnlineJudge

青岛大学的OnlineJudge，人家的毕业设计呢，界面好看，基于Docker，C和Java的沙箱设计挺完善的

https://github.com/QingdaoU/OnlineJudge/wiki/%E6%AD%A3%E5%BC%8F%E9%83%A8%E7%BD%B2%E6%96%87%E6%A1%A3

这是安装文档，需要安装Docker和docker-compose，注意其中python tools/release_static.py这一步是必须执行的

安装后的默认版本是不支持Python作为提交语言的，需要进行如下操作：

```
# 首先关掉容器
docker-compose stop
# 在master分支把那个分支merge过来
git merge origin/python-support
python tools/release_static.py
# 然后启动容器，注意要-d否则会占据前台
docker-compose up -d
```

-----

## sympy

https://github.com/sympy/sympy

http://docs.sympy.org/latest/tutorial/solvers.html

Python也能用来解方程！求极限！求积分！

-----

## shellcheck

检查自己写的shell脚本有没有问题

https://github.com/koalaman/shellcheck

https://www.shellcheck.net/

-----

## InstantClick

https://github.com/dieulot/instantclick

在鼠标悬停时即刻开始加载网页，显著提高网页加载速度，非常适合静态blog类型网页使用

----

## explainshell 

https://github.com/idank/explainshell

查询shell命令各个参数的含义

----

## Python Learn Notes

https://github.com/AnyISalIn/Python_Learn_Notes

一些不错的Python笔记

----

## websocketd

https://github.com/joewalnes/websocketd/

把linux程序的输出输出重定向到websocket，就可以实现网页上实时显示程序执行动态，官网：[http://websocketd.com/](http://websocketd.com/)
