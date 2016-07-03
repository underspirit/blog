+++
date = "2016-05-24T21:09:12+08:00"
tags = ["NLP"]
title = "Opinion Mining with Deep Recurrent Neural Networks笔记"
+++


本文对传统的RNN进行改进，结合BidirectionalRNN，提出了Deep bidirectional RNN。
<!--more-->
----------
![Alt text](/img/1464096878586.png)   

**传统的RNN**（图a）信息传播方向是从前往后一个方向，某个时刻t的隐藏状态仅仅包含它之前词语的语义信息：   
![Alt text](/img/1464097111614.png)   
$f$为非线性激活函数（比如sigmoid），$g$为输出的计算函数（比如softmax）。   

**Bidirectional RNN**（图b）包含前向和后向RNN两个部分，分别从相反的反向进行信息的传播，再将每个时刻的两个方向的隐藏状态联合起来计算输出值：   
![Alt text](/img/1464097064201.png)   

可以看到，前向RNN和反向RNN的参数是互相独立的。

**Deep  RNN**（图c）是将多个传统RNN进行叠加而来，即每一层计算隐藏状态的输入都为上一层的输出。  

**Deep Bidirectional  RNN**（图d）则是将Bidirectional RNN与Deep RNN结合起来：   
第$i$层（$i>1$）第$t$个时刻的前向隐藏状态$\overrightarrow{{h_t}^{(i)}}$依赖于三个输入：第$i-1$层$t$时刻的前向隐藏状态$\overrightarrow{{h_t}^{(i-1)}}$和后向隐藏状态$\overleftarrow{{h_t}^{(i-1)}}$以及第$i$层$t-1$时刻的前向隐藏状态.   
第$i$层（$i>1$）第$t$个时刻的后向隐藏状态$\overleftarrow{{h_t}^{(i)}}$的计算同理:   
![Alt text](/img/1464098995066.png)   

第1层隐藏状态机算比较特殊,也比较简单:   
![Alt text](/img/1464099041075.png)   

输出的计算有两种选择:一是使用所有时刻的隐藏状态计算输出,或者仅使用最后一个时刻的隐藏状态.这里使用第二种方案:   
![Alt text](/img/1464097751597.png)   

该文是通过堆叠（stack）RNN的方式达到Deep RNN的结构，[Pascanu等](http://arxiv.org/abs/1312.6026)的论文采取了另一种思路进行Deep RNN的扩展。
