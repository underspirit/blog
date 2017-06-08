+++
author = "songsong"
date = "2016-06-03T14:55:16+08:00"
description = ""
categories = ["Nature Language Processing"]
tags = ["NLP","RNN", "Encoder-Decoder", "Beam search"]
title = "Sequence to Sequence Learning with Neural Networks"

+++
      

该论文使用Encoder-Decoder模型, 进行end-to-end的训练来进行机器翻译. 该论文与[Neural Machine Translation By Jointly Learning To Align And Translate](http://blog.songru.org/posts/notebook/Neural_Machine_Translation_By_Jointly_Learning_To_Align_And_Translate_NOTE/)的主要区别在于:   

1. 该论文中不是使用Bidirectional RNN, 而是使用了multi-layer RNN, 发现比shallow RNN效果好(可能因为deep结构包含更多的隐藏状态).    
2. 该论文将输入序列进行反向, 再一次输入到Encoder的RNN中.   
正常顺序输入的Encoder序列与Decoder序列之间有一个比较大的"minimal time lag", 将输入序列方向之后, 虽然输入序列与输出序列对应词语之间的平均距离没有改变, 但是输入序列最前面的一些词语与输出序列的对应词语更加近了, 也就是说"minimal time lag"减小了.    
3. 该论文没有使用attention.   
4. 该论文在输出翻译句子时使用了[beam search](https://en.wikipedia.org/wiki/Beam_search)方法, 而不是传统的greedy search方法.   
<!--more-->
________
下面介绍一下Sequence to Sequence Learning当中的**beam search**:       
在训练好模型之后, 预测阶段我们需要逐个词语的进行预测, 通常的做法(greedy search)是从Decoder的第一个时刻开始选取概率最大的词作为下一个时刻的输入, 这样依次预测得到最终的结果. 但是这里存在一个问题, 就是**最可能的预测结果序列可能并不是从选取的最可能的那个词语开始的.**为了找到概率最大的预测结果, 可以简单的采用列举所有可能的输出序列, 然后选取最大概率的一个, 但是计算的复杂度与句子长度呈指数级增长, 效率太低.    

Beam search的思想是首先指定一个数$b$, 称$b$为beam size或beam width. 接下来要做的不是找到最有可能的第一个词, 而是第一个词中最可能的前$b$个(这$b$个候选词就成为beam); 接下来由第一个词预测第二个词, 依次使用选出的$b$个候选词进行预测, 并计算所有这些长度为2的序列的概率(一共$b*n$个这样的序列, $n$为词典大小), 从中选出概率最大的$b$个. 接下来使用前面选定的b个最大概率序列(长度为2)来计算概率最大的长度为3的前$n$个序列, 以此类推.      
Beam search的计算量是greedy search的$b$倍, $b$一般不会取太大(2-5貌似).    


>So the RNN estimates the joint distribution:   
>$p(X_1, X_2, X_3, \cdots, X_N)$ over a set of random variables   
>What we really want is the mode of this distribution, that is the point with the highest probability. One way to get this is through sampling from the joint distribution and taking the highest probability sample, but this is slow.    
>The RNN factors the joint distribution for 3 random variables in this way:   
>$$p(x_1, x_2, x_3) = p(x_3 \mid x_1,x_2) * p(x_2 \mid x_1) * p(x_1)$$   
>Beam search uses a heuristic that assumes that chains of random variables with high probability have fairly high probability conditionals. Basically you take the k highest probability solutions for $p(x_1)$, then for each of those take the k highest probability solutions for $p(x_2 \mid x_1)$. You then take the k of those with the highest value for $p(x_2 \mid x_1) * p(x_1)$ and repeat.   
