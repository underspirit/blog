+++
date = "2016-03-27T21:09:12+08:00"

tags = ["nlp"]
title = "Learning Phrase Representations using RNN Encoder–Decoder for Statistical Machine Translation笔记"

+++

本文主要创新在于提出一个新的神经网络模型RNN Encoder-Decoder，并提出GRU单元.将训练的模型作为standard phrase-based statistical machine translation system的一部分，用于计算phrase table中的每一个phrase的得分。

----------
**1. RNN Encoder-Decoder**
该模型由两个RNN组成，分别作为Encoder和Decoder，Encoder的作用是读取一个变长的序列数据，将其编码为一个固定长度的向量，再通过Decoder将这个向量解码为一个变长的序列数据.

Encoder为一个由GRU单元组成的RNN网络:   
![Alt text | center](/img/1458734687528.png)   
$e(x_t)$代表t时刻输入词的向量表示，初始的隐藏状态$h^{(0)}$固定为$0$，最后计算得出一个固定长度的编码结果：   
![Alt text | center](/img/1458735958249.png)   
Decoder也为一个由GRU单元组成的RNN网络:
它首先初始化隐藏状态：   
![Alt text | center](/img/1458736097645.png)   
其网络的计算公式为：   
![Alt text | center](/img/1458736032536.png)   
这里每一个时刻的计算都用到了Encoder传递过来的编码向量$c$，并且它的值是不变的。   
最后通过Softmax计算概率（没看懂），还有maxout。。。


