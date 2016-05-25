+++
date = "2015-09-22T10:09:12+08:00"

tags = ["ubuntu", "linux"]
title = "Linux命令（目前使用过的）"

+++
1. 移动文件（夹）

    	mv originalDir/source.txt targetDir/target.txt
2. 删除文件（夹）

		rm dir/target.file   //删除文件
		rm -r dir //删除文件夹
		<!--more-->
3. 利用软件源下载安装软件
	
		sudo apt-get install package 安装包
4. 解压文件
		
		tar -zxvf XXX压缩包
5. 创建文件夹
	
		mkdir dir    // -p参数可以创建子文件夹
6. 创建文件
	
		touch dir/a.txt
7. 解压文件
	
		tar -zxvf file.tar.gz    //解压到当前目录
		tar -zxvf file.tar.gz -C dir    //解压到制定目录
如果是zip格式的话：
	
		unzip  abc.zip -d /home/test/
8. 复制文件（夹）
	
		cp target.file copy.file    //复制文件
		cp -r targetDir copyDir //复制文件夹，使用-r递归复制
9. 打印当前路径
	
		pwd
10. 管理员权限
	
		sudo otherComand...		//使用root权限执行后续命令,一次性的
		sudo su    //登录root,以后的命令都是使用root权限
11. 查看文件系统使用情况信息
		
			df -Tha    //T显示分区类型，h易读格式，a显示所有   
			fdisk -l /dev/sda    // 查看指定磁盘分区情况
			parted /dev/sda    // parted为分区工具，p可查看分区情况，quit退出
			
12. 查看文件(夹)大小
		
		du filename/dir    //-s易于阅读,-h显示总览
13. 查看内存使用情况
		
		free -m    //-m表示单位为m
14. 任务管理器
	
		top     //退出按 q
15. 查看系统信息
		
		uname -a    //-a查看所有信息
16. 查看网络接口信息  
		
		ifconfig
17. MD5校验
		
		sudo md5sum filename
18. 查看文件(夹)权限情况
		
		ls -l path/filename      //查看path路径下名为filename的文件或文件夹的权限
		ls -ls path    //查看path路径下的所有文件的权限
19. 修改文件(夹)权限(change mode)
		
		sudo chmod -（代表类型）×××（所有者）×××（组用户）×××（其他用户）    //其中×××指文件名（也可以是文件夹名，不过要在chmod后加-ld）,使用 -R 参数来递归修改所有子文件   
		
		//三位数的每一位都表示一个用户类型的权限设置。取值是0～7，即二进制的[000]~[111],这个三位的二进制数的每一位分别表示读、写、执行权限。		
		//如000表示三项权限均无，而100表示只读。这样，我们就有了下面的对应：
		0 [000] 无任何权限
		4 [100] 只读权限
		6 [110] 读写权限
		7 [111] 读写执行权限

		//常用的
		sudo chmod 600 ××× （只有所有者有读和写的权限）
		sudo chmod 644 ××× （所有者有读和写的权限，组用户只有读的权限）
		sudo chmod 700 ××× （只有所有者有读和写以及执行的权限）
		sudo chmod 666 ××× （每个人都有读和写的权限）
		sudo chmod 777 ××× （每个人都有读和写以及执行的权限）

20. 修改文件所有者(change owner)
		
		sudo chown -R lsr software/    // -R 递归修改 software文件夹所有者为lsr
		
21. 读取文件
		
		cat a.txt	# 读取a.txt

22. 转换文件编码
		
		iconv -f gbk -t utf-8	# 将文件编码从gbk转到utf8
23. 查找行

		grep -E "<content>|<contenttitle>"	# 保留含有<content>或者<contenttitle>的行,-E表示使用正则
		grep -v "hehe" # -v 排除匹配的行

24. 删除文本中指定内容
		
		tr -d "<content>|<contenttitle>|</content>|</contenttitle>|>"	# -d表示删除,删除引号内的字符

25. 多个命令连续执行
		
		cat a.txt | iconv -f gbk -t utf-8 | grep -E "<content>|<contenttitle>" | tr -d "<content>|<contenttitle>|</content>|</contenttitle>|>" > corpus.txt

26. 查找文件
		
		find SogouCS/ -name "m_*"	# 在SogouCS目录中按文件名-name查找含有 m_*的文件

27. 命令参数传递

		# xargs将文件名传递过来, -i 表示使用传过来的参数替换 {}
		find SogouCS/ -name "m_*" | xargs -i mv {} SogouCS_M/

28. 大小写转换
		
		tr A-Z a-z	# 全部转换为小写

29. 文本替换

		# 替换’为'，′为'，'为' , -e 表示多个编辑,即多个sed同时, s表示替换,g表示全局替换
		sed -e "s/’/'/g" -e "s/′/'/g" -e "s/''/ /g"

		# 替换A-Za-z'_ \n之外的字符为空格,-c 表示排除..之外的都..
		tr -c "A-Za-z'_ \n" " "


		# 例子		     输入文件                                                                    输出到文件
		sed -e "s/’/'/g" -e "s/′/'/g" -e "s/''/ /g" < news.2012.en.shuffled | tr -c "A-Za-z'_ \n" " " > news.2012.en.shuffled-norm0

30. 从第3000行开始，显示1000行。即显示3000~3999行

		cat filename | tail -n +3000 | head -n 1000

31. 显示1000行到3000行

		cat filename| head -n 3000 | tail -n +1000
		*注意两种方法的顺序
		分解：
		    tail -n 1000：显示最后1000行
		    tail -n +1000：从1000行开始显示，显示1000行以后的
		    tail -n -1000：相当于tail -n 1000
		    head -n 1000：显示前面1000行
		    head -n +1000：显示前面1000行
		    head -n -1000：从第1行到倒数1000行
		   
32. 用sed命令
	
		sed -n '5,10p' filename # 查看文件的第5行到第10行, p表示打印匹配行
		sed -n '5p' filename # 只显示第5行
		sed -n '5,$p' filename # 查看文件的第5行到最后一行, $表示最后一行
		sed -n '3,/movie/'p temp.txt   # 只在第3行查找movie并打印

33. Linux统计文件行数
	
		wc -l file # - c 统计字节数, - l 统计行数, - w 统计字数。

		1.统计demo目录下，js文件数量：
		find demo/ -name "*.js" | wc -l
		
		2.统计demo目录下所有js文件代码行数：
		find demo/ -name "*.js" | xargs cat | wc -l 或 
		wc -l `find ./ -name "*.js"` | tail -n 1 # 取最后一行,总行数
		
		3.统计demo目录下所有js文件代码行数，过滤了空行：
		find /demo -name "*.js" | xargs cat | grep -v ^$ | wc -l

34. 打印进程信息
	
		ps aux
		
35. ssh连接主机,并执行命令
	
		ssh username@ip 'command'
36. shell中的一种for循环

		for((i=1;i<=10;i++))
		do
		    echo compute-0-$i
		    ssh compute-0-$i "nvidia-smi | grep '%' "
		 done

37. awk中的while循环

		awk 'BEGIN{s="";i=11}{while(i<=NF){ s=s" """$i;i++; } print s;}' # 提取出command ""用于拼接字符串, NF表示总的字段数
		
半角字符与全角字符之间的unicode码相差65248,而全角空格为12288,半角为32,需特殊对待.

java代码:	

	/**
	 * 全角转半角
	 * @param str
	 * @return
	 */
	public static String FullWidth2HalfWidth(String str){
		if (null == str || str.length() <= 0) {
            return "";
        }
		char []cs;
    	cs = str.toCharArray();
    	int k;
    	for(int i = 0; i < cs.length; i++){
    		k = (int)cs[i];
    		if(k >= 65281 && k <= 65374){
    			cs[i] -= 65248;
    		}else if(k == 12288 || k == 58380){
    			cs[i] = 32;
    		}
    	}
		return new String(cs);
	}

写的bat代码:

	@echo off
	echo Deploying updates to GitHub...

	:: Build the project.
	hugo -t red

	:: Add changes to git.
	git add -A

	:: Commit changes.
	set msg=rebuilding site %date% %time%
	if not "%1"=="" (
	  set msg=%1
	)
	git commit -m "%msg"

	:: Push source and build repos.
	git push origin hugo
	git subtree push --prefix=public origin master

	pause

对应的shell代码:

	#!/bin/bash
	echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"

	# Build the project.
	hugo -t red

	# Add changes to git.
	git add -A

	# Commit changes.
	msg="rebuilding site `date`"
	if [ $# -eq 1 ]
	  then msg="$1"
	fi
	git commit -m "$msg"

	# Push source and build repos.
	git push origin hugo
	git subtree push --prefix=public origin master


