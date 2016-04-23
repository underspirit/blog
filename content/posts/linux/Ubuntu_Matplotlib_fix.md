+++
date = "2016-04-23T10:09:12+08:00"

tags = ["ubuntu", "linux"]
title = "Ubuntu下matplotlib绘图中文乱码"

+++

原因：在Ubuntu下安装了各种中文字体，但是修改matplotlibrc文件后，均提示找不到该字体，猜测可能matplotlib字体列表与系统字体列表不同。

## 方法一（持久性修改）
1. 首先查看matplotlib支持的中文字体
```python
# -*- coding: utf-8 -*-
from matplotlib.font_manager import FontManager
import subprocess

fm = FontManager()
mat_fonts = set(f.name for f in fm.ttflist)

output = subprocess.check_output(
    'fc-list :lang=zh -f "%{family}\n"', shell=True)
# print '*' * 10, '系统可用的中文字体', '*' * 10
# print output
zh_fonts = set(f.split(',', 1)[0] for f in output.split('\n'))
available = mat_fonts & zh_fonts

print '*' * 10, '可用的字体', '*' * 10
for f in available:
    print f
```
输出为：
Droid Sans Fallback
YaHei Consolas Hybrid
就是求出系统字体列表与matplotlib字体列表的交集

2.修改matplotlibrc文件
Ubuntu默认对应的是/etc/matplotlibrc，可以复制到～/.matplotlibrc/matplotlibrc，然后配置后者即可
修改`font.sans-serif`为上面的一个输出结果即可。

## 方法二（临时性修改）
```python
# -*- coding: utf-8 -*-
 import matplotlib as mpl
 import matplotlib.pyplot as plt
 
 mpl.rcParams['font.sans-serif'] = ['Droid Sans Fallback'] # 指定字体名字
 plt.figure()
 plt.xlabel(u'性别')
 plt.ylabel(u'人数')
 plt.xticks((0,1),(u'男',u'女'))
```
或者：
```python
# -*- coding: utf-8 -*-
 import matplotlib.pyplot as plt
 from matplotlib import font_manager

 zh_font = font_manager.FontProperties(fname=r'/home/lsr/Documents/simsun.ttf', size=14) # 指定字体文件
 
 plt.figure()
 plt.xlabel(u'性别', fontproperties=zh_font) # 使用字体配置
 plt.ylabel(u'人数',fontproperties=zh_font)
 plt.xticks((0,1),(u'男',u'女')) # 没有使用字体配置，乱码
 plt.bar(left = (0,1),height = (1,0.5),width = 0.35)
 plt.show()
```


