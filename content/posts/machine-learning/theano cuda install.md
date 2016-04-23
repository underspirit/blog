+++
date = "2016-01-02T10:09:12+08:00"

tags = ["nlp"]
title = "Window7安装theano、anaconda、CUDA"

+++
最开始我使用的是anaconda3，但是一直没有成功，并且很多库对python2的支持更好，所以最好尝试使用anaconda2.
因为要使用mingw，但是新版的anaconda都没有自带mingw，所以下载了老版本anaconda1.9.2.
<!--more-->
# 1.安装CUDA

我的gpu是GTX 750ti|，使用的是CUDA7，安装简单（已久忘了细节，传说中使用默认路径安装好些，笔记本上是GTX 950M，CUDA7.5）。安装好CUDA后，跑程序可能遇到cuda is installed,but unavailale的错误，这个我查的结果说是显卡驱动太低，然后我就更新为最新的显卡驱动！！
安装完之后在cmd下执行nvcc -V查看版本成功的话，则表示小成。
要的话，进到sample目录，用相应的vs打开解决方案，然后生成解决方案，中途可能会有无法打开”d3dx9.h”、”d3dx10.h”、”d3dx11.h”头文件，可以[下载DXSDK_Jun10.exe](http://www.microsoft.com/en-us/download/details.aspx?id=6812)，然后安装到默认目录下；再编译工程即可；然后到bin目录跑生成的程序（deviceQuery.exe还有一些图形程序等），没问题的话则大成了。   
下面是一个详细的步骤（copy来的）:    
　　　1. 查看本机配置，查看显卡类型是否支持NVIDIA GPU，选中计算机--> 右键属性 --> 设备管理器 --> 显示适配器：NVIDIA GeForce GT 610，在[这里](https://developer.nvidia.com/cuda-gpus)可以查到相应显卡的compute capability；   
　　　2. 在[这里](http://www.nvidia.cn/Download/index.aspx?lang=cn)下载合适驱动347.88-desktop-win8-win7-winvista-64bit-international-whql.exe 并安装；  
　　　3. 从https://developer.nvidia.com/cuda-toolkit   根据本机类型下载相应的最新版本CUDA7.0安装；  
　　　4. 按照[官方文档](http://docs.nvidia.com/cuda/cuda-getting-started-guide-for-microsoft-windows/index.html#axzz3W8BU10Ol  )步骤，验证是否安装正确：   
　　　　　(1) 打开C:\ProgramData\NVIDIACorporation\CUDA Samples\v7.0目录下的Samples_vs2010.sln工程，分别在Debug、Release x64下编译整个工程；   
　　　　　(2) 编译过程中，会提示找不到”d3dx9.h”、”d3dx10.h”、”d3dx11.h”头文件，可以[下载DXSDK_Jun10.exe](http://www.microsoft.com/en-us/download/details.aspx?id=6812)，然后安装到默认目录下；再编译工程即可；   
　　　　　(3) 打开C:\ProgramData\NVIDIACorporation\CUDA Samples\v7.0\bin\win64\Release目录，打开cmd命令行，将deviceQuery.exe直接拖到cmd中，回车，会显示GPU显卡、CUDA版本等相关信息，最后一行显示：Result = PASS；   
　　　　　(4) 将bandwidthTest.exe拖到cmd中，回车，会显示Device0: GeForce GT 610等相关信息，后面也会有一行显示：Result = PASS； 

# 2.安装anaconda
开始使用的是anacond192版本，最后都配置成功了，但是这个版本的ipython notebook等等东西版本太低，我就用conda update了一下，导致一切都玩完了，theano又跑不起来了。所以后来就换成了anaconda2.4.1，是anaconda2的最新版本，但是没有mingw（这时我已经知道怎么配了，所以没有也不怕，我自己安）。   

1. 安装anaconda很简单，傻瓜式的   
2. 装mingw，运行conda install mingw即可   
3. 装theano，因为conda库中没有theano，所以使用pip安装，执行pip install theano即可   
4. 配置.theanorc.txt    

在home目录下(我的是c:/uesrs/lisongru)创建.theanorc.txt,输入一下内容

	[blas]
	ldflags =
	[gcc]
	cxxflags = -IE:\Anaconda2\MinGW    #安装的mingw目录
	[nvcc]
	fastmath = True
	flags=-LE:\Anaconda2\libs
	compiler-bindir=C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\bin   #vs的目录,不知是否可以不要,因为下面path也配了
	flags =  -arch=sm_30   #这句没有也行,好像,未测试
	base_compiledir=path_to_a_directory_without_such_characters   #这句没有也行,好像,未测试
	[global]
	openmp = False
	floatX = float32
	device = gpu   #cpu则使用cpu
	allow_input_downcast=True

# 3.配置环境变量
这一步非常关键,开始我的电脑有cygwin，并且也在path中，然后运行import theano总是报错，原因是cygwin被用来编译了，但我们要用的是。。。（我也不清楚),后来删除它的path,加入vs_bin的path,就好了.
下面是一些相关的path

	VS10_VC_BIN%		#vs的bin目录,和上面的compiler-bindir一样,这必须有,没有则包找不到cl.exe...
	%CUDA_PATH%\bin		#安装cuda好像默认会有,没有自己加,有它才能在cmd中nvcc -V查看
	C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v7.5\libnvvp;		#cuda安装自带
	C:\Program Files (x86)\NVIDIA Corporation\PhysX\Common		#自带
	%ANACONDA2_HOME%;%ANACONDA2_SCRIPTS%;%ANACONDA2_BIN%		#anaconda自带
	
# 4.遇到的问题
在笔记本上安装好一切后，报collect2: ld returned 1 exit status错，查的结果说是python 32位与64位冲突，那时笔记本上正好有32位的一个python，就卸载了，但还是不行。
再查，说是少了libpython包,安装之:conda install libpython，然后就好了。。。（这里有点奇怪，在台式机上没有这个包也成功了）。   
> Written with [StackEdit](https://stackedit.io/).