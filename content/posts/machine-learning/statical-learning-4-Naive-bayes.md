+++
date = "2015-07-07T10:34:24+08:00"
description = ""
tags = ["ML"]
title = "统计学习方法读书笔记(4)-朴素贝叶斯算法"

+++

朴素贝叶斯(naïve Bayes)法是基于**贝叶斯定理与特征条件独立假设**的分类方法。对于给定的训练数据集,首先基于特征条件独立假设学习输入/输出的**联合概率分布**;然后基于此模型,对给定的输入x,利用贝叶斯定理求出后验概率最大的输出y。

# 定义:
设输入空间`$\mathcal{X}⊆R^n$`为n维向量的集合,输出空间为类标记集合`$ \mathcal{Y} = \{c_1,c_2, \cdots ,c_K\}$`。输入为特征向量`$x \in \mathcal{X}$`,输出为类标记(class label)`$y \in \mathcal{Y}$ `。`$X$`是定义在输入空间`$\mathcal{X}$`上的随机向量,`$Y$`是定义在输出空间`$\mathcal{Y}$`上的随机变量. `$P(X,Y)$`是`$X$`和`$Y$`的联合概率分布。    

训练数据集`$T=\{(x_1,y_1),(x_2,y_2),\cdots,(x_N,y_N) \}$`,由`$P(X,Y)$`独立同分布产生。     
其中`$x_i = (x_i^{(1)}, x_i^{(2)}, \cdots , x_i^{(n)})^T$`, `$x_i^{(j)}$`是第i个样本的第j个特征, `$x_i^{(j)} \in \{a_{j1},a_{j2}, \cdots ,a_{jS_j} \}$`, `$a_{jl}$`是第j个特征可能取的第l个值, `$j=1,2, \cdots ,n$` , `$l=1,2, \cdots ,S_j $`, `$y_i \in \{c_1,c_2, \cdots ,c_K\} $`;   

朴素贝叶斯法通过训练数据集学习联合概率分布`$P(X,Y)$`, 再根据贝叶斯公式
`$$ P(Y \mid X) = \frac{P(X, Y)}{P(X)}  = \frac {P(X \mid Y) P(Y) }  {\sum \limits_Y P(X \mid Y) P(Y)}$$`
求出后验概率。   

朴素贝叶斯法分类时,对给定的输入x,通过学习到的模型计算后验概率分布`$P(Y=c_k|X=x)$`,将后验概率最大的类作为x的类输出。后验概率计算根据贝叶斯公式进行: 
`$$ 
\begin{align}
P(Y=c_K \mid X = x) &= \frac{P(X = x, Y = c_k)}{P(X = x)}  \\ 
&= \frac {P(X = x \mid Y = c_k) P(Y = c_k) }  {\sum_{k=1}^K P(X = x \mid Y = c_k) P(Y = c_k)}
\end{align}
$$`

具体地,需要学习以下先验概率分布`$P(Y=c_k)$`及条件概率分布`$P(X = x \mid Y = c_k)$`。    

# 求解方法, 极大似然估计方法:   
先验概率分布
`$$ P(Y=c_K) = \frac{\sum_{i=1}^{N} I(y_i = c_k)} {N} , \quad k=1,2,\cdots,K $$`

条件概率分布:
`$$  P(X=x \mid Y = c_k) = P(X^{(1)} = x_{(1)}, \cdots, X^{(n)} = x_{(n)} \mid Y=c_k) \quad  k=1,2,\cdots,K $$`
首先朴素贝叶斯法对条件概率分布作了**条件独立性的假设**。由于这是一个较强的假设,朴素贝叶斯法也由此得名。具体地,条件独立性假设是
`$$
\begin{align}  
  P(X=x \mid Y=c_k)  &= P(X^{(1)} = x_{(1)}, \cdots, X^{(n)} = x_{(n)} \mid Y=c_k)    \\  
             &= \prod_{j=1} ^n P( X^{(j)} = x^{(j)} \mid Y = c_k )  \\
  P(X^{(j)} = a_{jl} \mid Y = c_k) &=  \frac {\sum_{i=1}^N I(x_i^{(j)} = a_{jl}, y_i = c_k) } {\sum_{i=1}^N I(y_i = c_k)}
\end{align} 
$$`
**条件独立假设等于是说用于分类的特征在类确定的条件下都是条件独立的**。这一假设使朴素贝叶斯法变得简单,但有时会牺牲一定的分类准确率。

最终后验概率为:
`$$ P(Y = c_k \mid X = x)  =  \frac{P(Y = c_k) \prod_{j=1}^n P(X^{(j)} = x^{(j)} \mid Y = c_k)}  { \sum_{k=1}^K \left( P(Y = c_k) \prod_{j=1}^n P(X^{(j)} = x^{(j)} \mid Y = c_k) \right) }  \quad \text{(K为类别个数, n为特征个数)}$$`

朴素贝叶斯分类器可表示为
`$$ y = f(x) = \arg \max_{c_k} \frac{P(Y = c_k) \prod_{j=1}^n P(X^{(j)} = x^{(j)} \mid Y = c_k)}  { \sum_{k=1}^K \left( P(Y = c_k) \prod_{j=1}^n P(X^{(j)} = x^{(j)} \mid Y = c_k) \right) } $$`

其中分母对所有$c_k$都是相同的,所以
`$$ y = f(x) = \arg \max_{c_k} P(Y = c_k) \prod_{j=1}^n P(X^{(j)} = x^{(j)} \mid Y = c_k) $$`
朴素贝叶斯法实际上学习到生成数据的机制,所以**属于生成模型**。

# 贝叶斯估计(平滑)
用极大似然估计可能会出现所要估计的概率值为0的情况。这时会影响到后验概率的计算结果,使分类产生偏差。解决这一问题的方法是采用贝叶斯估计。具体地,条件概率的贝叶斯估计是
`$$  P(X^{(j)} = a_{jl} \mid Y = c_k) =  \frac {\sum_{i=1}^N I(x_i^{(j)} = a_{jl}, y_i = c_k) + \lambda} {\sum_{i=1}^N I(y_i = c_k) + S_j \lambda}  $$`   

式中`$ \lambda ≥0$`。等价于在随机变量各个取值的频数上赋予一个正数`$ \lambda>0$`。当`$ \lambda=0$`时就是极大似然估计。常取`$ \lambda = 1$`, 这时称为拉普拉斯平滑(Laplace smoothing)。


# 后验概率最大化的含义(不是很懂)
朴素贝叶斯法将实例分到后验概率最大的类中。这**等价于期望风险最小化**。假设选择0-1损失函数:
`$$ L(Y, f(X)) = \begin{cases}
				1, & Y \ne f(X) \\
				0, & Y = f(X)
				\end{cases}
$$`
式中`$f(X)$`是分类决策函数。这时,期望风险函数为
`$$ R_{exp}(f) = E [L(Y, f(X))] $$`
期望是对联合分布$P(X,Y)$取的。由此取条件期望
`$$ R_{exp}(f) = E_X \sum_{k=1}^K[ L(c_k, f(X)) ] P(c_k \mid X)$$`
为了使期望风险最小化,只需对`$X=x$`逐个极小化,由此得到:
`$$
\begin{align}  
  f(x) &= \arg \max_{y \in \mathcal{Y}} \sum_{k=1}^K L(c_k, y) P(c_k \mid X = x)  \\
  &= \arg \max_{y \in \mathcal{Y}} \sum_{k=1}^K P(y \ne  c_k \mid X =x ) \\
  &= \arg \min_{y \in \mathcal{Y}} (1 - P(y = c_k \mid X =x)) \\
  &= \arg \max_{y \in \mathcal{Y}} P(y = c_k \mid X = x)
\end{align} 
$$`
这样一来,根据期望风险最小化准则就得到了后验概率最大化准则:
`$$ f(x) = \arg \max_{c_k} P( y = c_k \mid X = x)  $$`
即朴素贝叶斯法所采用的原理。

