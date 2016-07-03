+++
date = "2016-03-27T22:09:12+08:00"

tags = ["NLP"]
title = "Neural Machine Translation By Jointly Learning To Align And Translate笔记"

+++

本文主要创新在传统的神经机器翻译上进行改进，确切的说是改进了基本的RNN Encoder-Decoder模型,提出了Alignment model，即实现了Attention model.
<!--more-->
----------
传统的encoder-decoder模型如下图所示:
![Alt text | center](/img/1458651310553.png)   
该模型通过神经网络将所有的输入信息压缩为一个固定长度的向量$w$,然后通过decoder的神经网络解码这个$w$，最后得出翻译结果.   
使用固定长度的向量是该模型的一个缺点,因为该向量很难将所有需要的信息编码到其中，对于长度大的句子,该模型的效果会显著下降.

本文作者提出的改进模型结构为:   
![Alt text | center](/img/1458651809449.png)   
主要有4个方面改进:   
1. **GRU 和 Bidirectional RNN**   
RNN网络的结果采用的是GRU单元，双向神经网络(Bidirectional).一个BiRNN由前向(forward)和后向(backward)RNN组成,前向RNN &(\stackrel{\rightarrow}{\mbox{f}})& 按顺序读取输入序列(从&(x\_f)&到&(x\_{T\_x})&)，计算得出前向RNN的隐含状态序列&((\\vec{h\_1},\\cdots,\\vec{h\_{T\_x}} ))& 。反向RNN$\\stackrel{\\leftarrow}{\\mbox{f}}$则逆序读取输入序列(从$x\_{T\_x}$到$x\_1$)，计算得出$(\\stackrel{\\leftarrow}{h\_1},\\cdots,\\stackrel{\\leftarrow}{h\_{T\_x}})$ .   
对于一个词$x_j$直接concatenating前向$\vec{h_j}$与后向$\stackrel{\leftarrow}{h_j}$，即$h\_j=\\left[\\begin{array}{c}\\stackrel{\\rightarrow}{h\_j}  \\\  \\stackrel{\\leftarrow}{h\_j}  \\end{array} \\right]$，计算时词向量矩阵$E$是前向与后向网络共享的，其他参数则不是.    
2. **对齐模型(alignment model)**   
该模型也可以说是实现了注意力模型(Attention model).   
通过该模型计算得到输入时刻$j$在预测输出时刻$i$时所占的权重$\alpha _{ij}$.比如说翻译**"我喜欢飞机"**到**"I like airplane"**,翻译输出**"I"**时，**"我"**字所占的权重会比较大.   
权重$\alpha _{ij}$是通过一个单层的多层感知机计算得到,该模型与算法中其他部分同时训练:   
![Alt text | center](/img/1458736905308.png)   
3. **Encoder 和 Decoder**   
Encoder的计算如下：   
![Alt text | center](/img/1458737365201.png)   
$E$表示词向量的矩阵，$x_i$表示$i$时刻的词,是一个$k$维的向量(词典大小维度的向量,应该是one-hot的)，反向过程的计算与上面类似。   

Decoder的计算如下：   
![Alt text | center](/img/1458737469906.png)   
初始的隐藏状态为：$$s_0 = tanh(W_s\stackrel{\leftarrow}{h_1})$$   
每一步的context向量都需要通过Alignment model重新计算:   
![Alt text | center](/img/1458738176634.png)   
![Alt text | center](/img/1458738239955.png)   
最后计算$y_i$的概率:   
![Alt text | center](/img/1458738415785.png)   
![Alt text | center](/img/1458738447372.png)   
![Alt text | center](/img/1458738462004.png)   
使用了maxout（第二个公式），取相邻两个数中较大的一个。需要计算词典中所有词出现的概率，最后取最大的那一个？


**具体的实现细节见论文的附录**

