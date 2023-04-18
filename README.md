# 简介

本项目是根据[自己动手写CPU](https://book.douban.com/subject/25960657/)这本书编写的一个简单的MIPS32架构的最小系统，包括一个简单的MIPS32架构的CPU，一个指令ROM，一个数据RAM。本项目在ModelSim中使用Verilog编写。

该最小系统SOPC实现了一个五级流水线的MIPS32架构的CPU，只完成了基础的31条MIPS指令（在同目录下的《MiniSys的31条指令》中给出）。基本上完成了基础篇的编写，但是没有实现**异常模块**和**协处理器模块**。



