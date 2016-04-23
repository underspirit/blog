+++
date = "2015-09-11T10:09:12+08:00"

tags = ["nlp"]
title = "【自然语言处理之二】文本处理基础（Basic Text Processing）"

+++
# 一、文本处理基础
## 1.1 正则表达式
自然语言处理过程中面临大量的文本处理工作，如词干提取、网页正文抽取、分词、断句、文本过滤、模式匹配等任务，而正则表达式往往是首选的文本预处理工具。
现在主流的编程语言对正则表达式都有较好的支持，如Grep、Awk、Sed、Python、Perl、Java、C/C++(推荐re2)等。
*注：课程中给出的正则表达式语法和示例在此略去*
<!--more-->
## 1.2 分词
分词的操作就是将一句话中的词语全部切分开来。

### 1.2.1 词典规模
同一词条可能存在不同的时态、变形，那么给定文本语料库，如何确定词典规模呢？
首先定义两个变量Type和Token：
    **Type**：词典中的元素，即独立词条
    **Token**：词典中独立词条在文本中的每次出现
如果定义 N = number of tokens 和 V = vocabulary = set of types，|V| is the size of the vocabulary，那么根据Church and Gale (1990)的研究工作可知: |V| > O(N½) ，验证如下：   
![词典规模](/img/nlp_2_1.jpg)

### 1.2.2 分词算法
任务：统计给定文本文件（如shake.txt）中词频分布，子任务：分词，频率统计，实现如下：

英文分词非常简单，因为英文中每个单词之间（少数特殊写法额外考虑，We're,isn't...)都由空格分割开来，所以分词只需要按空格将它们切分，然后对一些特殊的写法进一步处理即可。   
![分词算法](/img/nlp_2_2.jpg)   
以上实现将非字母字符作为token分隔符作为简单的分词器实现，但是，这难免存在许多不合理之处，如下面的例子：   

		- Finland’s capital  ->  Finland Finlands Finland’s  ?
		- what’re, I’m, isn’t  ->  What are, I am, is not
		- Hewlett-Packard   ->  Hewlett Packard ?
		- state-of-the-art     ->   state of the art ?
		- Lowercase  ->  lower-case lowercase lower case ?
		- San Francisco ->   one token or two?
		- m.p.h., PhD.  ->  ??
上面的方法对英语这种包含固定分隔符的语言行之有效，对于汉语、日语、德语等文本则不再适用，所以就需要专门的分词技术。其中，最简单、最常用，甚至是最有效的方法就是最大匹配法（Maximum Matching），它是一种基于贪心思想的切词策略，主要包括正向最大匹配法（Forward Maximum Matching，FMM）、逆向最大匹配法（Backward Maximum Matching）与双向最大匹配法（Bi-direction Maximum Matching，BMM）。

以FMM中文分词为例，步骤如下：
1.  选取包含N(N通常取6~8)个汉字的字符串作为最大字符串；
2. 把最大字符串与词典中的单词条目相匹配（词典通常使用Double Array Trie组织）；
3. 如果不能匹配，就去除最后一个汉字继续匹配，直到在词典中找到相应的词条为止。
例如：句子“莎拉波娃现在居住在美国东南部的佛罗里达“的分词结果是”莎拉波娃/   现在/   居住/   在/  美国/   东南部/     的/  佛罗里达/”。
另外，使用较多的分词方法有最少分词法、最短路径法、最大概率法（或词网格法，大规模语料库+HMM/HHMM）、字标注法等。

### 1.2.3 分词难点
-切分歧义：主要包括交集型歧义和覆盖型歧义，在汉语书面文本中占比并不大，而且一般都可以通过规则或建立词表解决。

-未登录词：就是未在词典中记录的人名（中、外）、地名、机构名、新词、缩略语等，构成了中文自然语言处理永恒的难点。常见的解决方法有互信息、语言模型，以及基于最大熵或隐马尔科夫模型的统计分类方法。

## 1.3 文本归一化(标准化)
文本归一化主要包括大小写转换、词干提取、繁简转换等问题。

## 1.4 断句
句子一般分为大句和小句，大句一般由“！”，“。”，“；”，“\“”、“？”等分割，可以表达完整的含义，小句一般由“，”分割，起停顿作用，需要上下文搭配表达特定的语义。
中文断句通常使用正则表达式将文本按照有分割意义的标点符号(如句号)分开即可，而对于英文文本，由于英文句号”.“在多种场景下被使用，如缩写“Inc.”、“Dr.”、“.02%”、“4.3”等，无法通过简单的正则表达式处理，为了识别英文句子边界，课程中给出了一种基于决策树（Decision Tree）的分类方法，如下图所示：   
![断句](/img/nlp_2_3.jpg)   
此方法的核心就是如何选取有效的特征？如句号前后的单词是否大写开头、是否为缩略词、前后是否存在数字、句号前的单词长度、句号前后的单词在语料库中作为句子边界的概率等等。当然，你也可以基于上述特征采用其他分类器解决断句问题，如罗辑回归（Logistic regression）、支持向量机（Support Vector Machine）、神经网络（Neural Nets）等。

# 二、参考资料
1. Lecture Slides：[Basic Text Processing] [1]
2. [http://en.wikipedia.org] [2]
3. 关毅，统计自然语言处理基础 课程PPT
4. [Gale, W. A. and K. W. Church (1990) “Estimation Procedures for Language Context: Poor Estimates are Worse than None,” Proceedings in Computational Statistics, 1990, p.69-74, Physica-Verlag, Heidelberg] [3] .
5. [matrix67-漫话中文分词算法] [4]
6. [中文分词入门之字标注法] [5]

[1]: http://spark-public.s3.amazonaws.com/nlp/slides/textprocessingboth.pptx
[2]: http://en.wikipedia.org
[3]: http://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=4&ved=0CHAQFjAD&url=http%3A%2F%2Fwww2.denizyuret.com%2Fref%2Fchurch%2Fpublished_1990_darpa.ps.gz&ei=guWlT4rCFOWZ2QW3mbymAg&usg=AFQjCNFcEeYyaP8TQUYJxNVUkdoHZl98hg&sig2=17cCPZhMQzpWCHeWm-knag
[4]: http://www.52nlp.cn/matrix67-%E6%BC%AB%E8%AF%9D%E4%B8%AD%E6%96%87%E5%88%86%E8%AF%8D%E7%AE%97%E6%B3%95
[5]: http://www.52nlp.cn/%E4%B8%AD%E6%96%87%E5%88%86%E8%AF%8D%E5%85%A5%E9%97%A8%E4%B9%8B%E5%AD%97%E6%A0%87%E6%B3%A8%E6%B3%951

> Written with [StackEdit](https://stackedit.io/).
