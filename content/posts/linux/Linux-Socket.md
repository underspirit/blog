+++
date = "2017-03-18T09:54:01+08:00"
description = ""
tags = ["Linux", "Socket"]
title = "Linux Socket使用小结"

+++

**1. 关于recv, read, write, send方法**
recv较read多了一个flag参数，如果flag为0，则recv相当于read，write与send类似。

**2. 关于阻塞**
recv方法默认会阻塞，直到有数据读取或者对方关闭了socket。返回读取到的字节数，这个数可能会小于指定要读取的大小，所以socket编程应该是需要自己协商需要读取的数据长度（比如把长度放在最开始）。
send方法默认不会阻塞，send之后立马返回，数据应该是已经发送到了网络上。

**3. 总结**
socket就有点像是两个命名管道， `pipe_1[]` 与 `pipe_2[]`比如：
server端读取的是`pipe_1[0]`的数据，client端向`pipe_1[1]`写入数据。
client端读取的是`pipe_2[0]`的数据，server端向`pipe_2[1]`写入数据。
读数据时默认会阻塞，等待另一端向管道写入数据；写数据默认不阻塞，写入的数据直接到pipe中去了，就算写入端关闭了socket，读写的还能从pipe中获取已写入的数据。

可以通过select函数检测文件描述符的状态，比如有数据可读时则去读之类的。
