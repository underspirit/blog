+++
date = "2017-03-18T09:53:43+08:00"
description = ""
categories = ["Linux"]
tags = ["IPC"]
title = "Linux IPC总结(Posix和System V对比)"

+++

## 1. 管道(Pipe)
### 1.1 匿名管道(Unnamed Pipe) 
#### 1.1.1 popen
```
#include <stdio.h>
FILE* popen (const char *command, const char *open_mode);
int pclose(FILE *stream_to_close);
```
　　popen()函数通过创建一个管道，调用fork()产生一个子进程，执行一个shell以运行命令来开启一个进程。这个管道必须由pclose()函数关闭，而不是fclose()函数。pclose()函数关闭标准I/O流，等待命令执行结束，然后返回shell的终止状态。如果shell不能被执行，则pclose()返回的终止状态与shell已执行exit一样。

　　type参数只能是读或者写中的一种，得到的返回值（标准I/O流）也具有和type相应的只读或只写类型。如果type是"r"则文件指针连接到command的标准输出；如果type是"w"则文件指针连接到command的标准输入。
```
 #include <unistd.h>
 #include <stdlib.h>
 #include <stdio.h>
 #include <string.h>
 
 int main()
 {
     FILE *read_fp = NULL;
     FILE *write_fp = NULL;
     char buffer[BUFSIZ + 1]; 
     printf("BUFSIZ: %d\n", BUFSIZ);
     int chars_read = 0;
     
     //初始化缓冲区
     memset(buffer, '\0', sizeof(buffer));
     //打开ls和grep进程
     read_fp = popen("ls -l /home/lsr", "r");
     write_fp = popen("grep rwxrwxr-x", "w");
     //两个进程都打开成功
     if(read_fp && write_fp)
     {   
         //读取一个数据块
         chars_read = fread(buffer, sizeof(char), BUFSIZ, read_fp);
         while(chars_read > 0)
         {
             //设置结尾字符
             buffer[chars_read] = '\0';
             //把数据写入grep进程
             fwrite(buffer, sizeof(char), chars_read, write_fp);
             //还有数据可读，循环读取数据，直到读完所有数据
             chars_read = fread(buffer, sizeof(char), BUFSIZ, read_fp);
         }
         //关闭文件流
         pclose(read_fp);
         pclose(write_fp);
         exit(EXIT_SUCCESS);
     }   
     exit(EXIT_FAILURE);
```

#### 1.1.2 pipe
```
#include <unistd.h>
int pipe(int file_descriptor[2]);
```
`pipe`函数跟`popen`函数的一个重大区别是，`popen`函数是基于文件流（FILE）工作的，而`pipe`是基于文件描述符工作的，所以在使用`pipe`后，数据必须要用底层的`read`和`write`调用来读取和发送。

`pipe`函数会创建两个文件描述符, 并且不要用`file_descriptor[0]`写数据，也不要用`file_descriptor[1]`读数据，其行为未定义的，但在有些系统上可能会返回-表示调用失败。数据只能从`file_descriptor[0]`中读取，数据也只能写入到`file_descriptor[1]`, 不能倒过来。

它的一个**缺点**，就是通信的进程，它们的关系一定是父子进程的关系，这就使得它的使用受到了一点的限制，但是我们可以使用命名管道来解决这个问题。

### 1.2 命名管道(Named Pipe)
命名管道也被称为FIFO文件，它是一种特殊类型的文件，它在文件系统中以文件名的形式存在，但是它的行为却和之前所讲的没有名字的管道（匿名管道）类似。
```

#include <sys/types.h>
#include <sys/stat.h>
int mkfifo(const char *filename, mode_t mode);
int mknod(const char *filename, mode_t mode | S_IFIFO, (dev_t)0);
```

这两个函数都能创建一个FIFO文件，注意是创建一个真实存在于文件系统中的文件，filename指定了文件名，而mode则指定了文件的读写权限。
`mknod`是比较老的函数，而使用`mkfifo`函数更加简单和规范，所以建议在可能的情况下，尽量使用`mkfifo`而不是`mknod`。
在Linux系统的shell下, 也可以使用`mkfifo`或者`mknod`命令创建管道文件, 然后通过流重定向`echo hello > myfifo`可以向管道写入, 通过`cat mypipe`可以读取管道数据.

在C++程序中, 也是使用`open`函数打开一个管道, 然后在不同的进程中可以只用`read`和`write`函数读取和写入数据到管道中.

## 2. 信号(Signal)
信号是UNIX和Linux系统响应某些条件而产生的一个事件，接收到该信号的进程会相应地采取一些行动。通常信号是由一个错误产生的。但它们还可以作为进程间通信或修改行为的一种方式，明确地由一个进程发送给另一个进程。一个信号的产生叫生成，接收到一个信号叫捕获。
```
#include <signal.h>
void (*signal(int sig, void (*func)(int)))(int);
```
程序可用使用`signal`函数来指定接受到某种信号后的处理方式，也可以选择忽略和恢复其默认行为来工作。

`signal`函数定义的是某一个信号的行为, 我们还可以使用信息集的系列函数来定义多个信号的行为, 比如可以设定一些我们需要处理的信号，并设置一些我们不需要处理的信号.


## 3. 信号量(Semaphore)
信号量的使用主要是用来**保护共享资源**，使得资源在一个时刻只有一个进程（线程）所拥有。
信号量的值为正的时候，说明它空闲。所测试的线程可以锁定而使用它。若为0，说明它被占用，测试的线程要进入睡眠队列中，等待被唤醒。

### 3.1 POSIX信号量
对POSIX来说，信号量是个**非负整数**。常用于线程间同步。
POSIX信号量的引用头文件是`<semaphore.h>`, 其相关函数名都是sem_op这个带下划线的形式.

### 3.1.2 无名信号量
无名信号量常用于多线程间的同步，同时也用于相关进程间的同步。也就是说，无名信号量必须是多个进程（线程）的共享变量，无名信号量要保护的变量也必须是多个进程（线程）的共享变量，这两个条件是缺一不可的。
POSIX无名信号量由`sem_init`函数创建:
```
#include <semaphore.h>
int sem_init(sem_t *sem, int pshared, unsigned int value);

Link with -pthread.
```
## 4. 共享内存(Shared memory)

## 5. 消息队列(Message queue)
