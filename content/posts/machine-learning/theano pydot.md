+++
date = "2016-01-03T10:09:12+08:00"

categories = ["Machine Learning"]
tags = ["theano"]
title = "Theano 中使用pydot报错"

+++
运行:

	# 切换为使用cpu,有这句var_with_name_simple=True的时候会报错...,换成gpu就不报错...
	theano.printing.pydotprint(forward_prop, var_with_name_simple=True, compact=True, outfile='img/nn-theano-forward_prop.png', format='png')
报错:

	pywintypes.error(2,'RegOpenKeyEx','\xcf\xb5\xcd\xb3\xd5\xd2\xb2\xbb\xb5\xb...
<!--more-->
原因是未安装好graphviz,于是下载[安装包](http://www.graphviz.org/Download_windows.php),并把安装目录的bin加入到path中(重要!)

后来又报错:

	RuntimeError: Failed to import pydot. You must install pydot for `pydotprint` to work.
原因是使用的pyparsing版本太高(我的是2.0.3),使用低版本的即可:

		pip install pyparsing==1.5.7
我还安装了pydot2,不知有什么用:   

		pip install pydot2
我之后做了一个实验,再把pyparsing升级到2.0.3,报了一个不一样的错:

	InvocationException: Program terminated with status: -1073741819. stderr follows: []
将pyparsing再降级即可....	
	

	

	
> Written with [StackEdit](https://stackedit.io/).
