+++
date = "2017-03-18T09:36:53+08:00"
description = ""
tags = ["Linux"]
title = "Ubuntu 14.04 笔记本双显卡cuda 安装"

+++

# Ubuntu 14.04 笔记本双显卡cuda 安装

1. 安装ubuntu系统
2. 在系统设置 ->  软件和更新 -> 附加驱动 中如果有nvidia驱动， 则表示该系统支持cuda， 可以继续后面步骤。
3. 下载新版的NVIDIA显卡驱动， CUDA的run file里面的驱动或者是deb中的都太老了, 不适合新版tensorflow。
4. 安装新版的NVIDIA驱动：    
```sh NVIDIA-Linux-x86_64-375.26.run -no-x-check -no-nouveau-check -no-opengl-files```
–no-x-check 安装驱动时关闭X服务 
–no-nouveau-check 安装驱动时禁用nouveau 
–no-opengl-files 只安装驱动文件，不安装OpenGL文件
5. 通过run文件安装cuda，选择不安装显卡驱动
6. 成功
