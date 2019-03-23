# 生物智能算法 神经网络组

## Personal information
+ Name: 程书意
+ Student ID: 21821255
+ Email: 1541189572@qq.com

---

## Timeline

|Task|Date|Done|
--|--|:--:
1.选择论文|Mar. 14|
2.精读论文，理解模型|Mar. 21|
3.复现论文|Apr. 4|
4.完成对比实验|Apr. 11|
5.形成报告|Apr. 18|

---

## 1. 选择论文

[Learning Deconvolution Network for Semantic Segmentation](https://arxiv.org/abs/1505.04366)

> [IEEE 2015 IEEE International Conference on Computer Vision (ICCV) - Santiago, Chile (2015.12.7-2015.12.13)] 2015 IEEE International Conference on Computer Vision (ICCV) - Learning Deconvolution Network for Semantic Segmentation

### 1.1 Abstract

We propose a novel semantic segmentation algorithm by learning a deconvolution network. We learn the network on top of the convolutional layers adopted from VGG 16-layer net. The deconvolution network is composed of deconvolution and unpooling layers, which identify pixel-wise class labels and predict segmentation masks. We apply the trained network to each proposal in an input image, and construct the final semantic segmentation map by combining the results from all proposals in a simple manner. The proposed algorithm mitigates the limitations of the existing methods based on fully convolutional networks by integrating deep deconvolution network and proposal-wise prediction; our segmentation method typically identifies detailed structures and handles objects in multiple scales naturally. Our network demonstrates outstanding performance in PASCAL VOC 2012 dataset, and we achieve the best accuracy (72.5%) among the methods trained with no external data through ensemble with the fully convolutional network.

### 1.2 摘要

作者提出了一个新颖的通过学习反卷积网络来进行语义分割的算法。作者在来VGG16层的卷积层之上来构建学习网络。反卷积网络由反卷积和反池化层组成，用来确定像素级别的类别标签预测分割掩码。对于每个输入图像，作者将训练好的网络应用到每一个方案中，然后通过一个简单的方式将所有方案的结果结合，来构建最后的语义分割映射。作者提出的算法通过整合深度反卷积网络和每个方案的预测结果，减轻了现有的基于全卷积网络的方法的限制；该分割方法常常自然地确定精细的结构，并且处理多个尺度的物体。我们的网络在PASCAL VOC 2012数据集上展现出杰出的性能，我们在那些没有额外数据的训练方法中，通过与全卷积网络整合，最终获得了72.5％的准确率。

## 2. 精读论文，理解模型

### 2.1 简介

##### 2.1.1 FCN VS. DCN

* 固定尺寸的感受野

    - 对于大尺度目标，只能获得该目标的**局部信息**，该目标的一部分将被错误分类；
![大尺度目标错误分类](./image/1.png)
    - 对于小尺度目标，很容易被忽略或当成背景处理；
![小尺度目标错误分类](./image/2.png)

* 目标的细节结构容易丢失，边缘信息不够好。全卷积神经网络得到的分类图过于粗糙，而用于上采样的反卷积操作过于简单；

![细节丢失](./image/3.png)

#### 2.1.2 贡献

* 作者学习了一个多层反卷积网络，它由反卷积、反池化和ReLU层组成。

* 训练的模型被用来进行单个物体的提出，以获得实例级别的分割，并最终结合到语义分割中。这种模型消除了在基于FCN模型中发现的尺度问题，同时更好的确定了物体的细节。

* 作者使用反卷积网络，在仅在PASCAL VOC 2012数据集上训练的情况下就取得了很好的效果，通过利该算法相对于基于FCN模型的异质性和互补性，与FCN模型进行集成并获得了最好的准确率。

### 2.2 系统结构

作者训练的网络由**卷积网络**和**反卷积网络**两部分组成。卷积网络与将输入图像转化到多维度特征表示的**特征抽取**相对应，而反卷积网络是一个从卷积网络得到的抽取的特征来得到目标分割的的形状生成器。网络最终的输出使用和输入图像大小一致的概率映射，**表明了每个像素属于某一预定义分类的概率**。

作者使用去除了最后分类层的VGG16层网络作为卷积部分。该卷积网络一共有13个卷积层，在卷积层之间有rectification和池化操作，在最后增加两个全连接层来进行特定类的映射。反卷积网络是卷积网络的镜像版本，有多个系列的反池化、反卷积和规范化层。与卷积网络中通过前馈来减少激活大小不同，反卷积网络通过将反池化和反卷积操作结合来增大激活大小。

![网络结构](./image/4.png)

* 反池化

池化在卷积网络中被设计用来通过在一个感受野内抽取一个代表值来过滤噪声。尽管这通过在上层仅保留鲁棒的像素点来帮助分类，但是在池化的过程中感受野内的**空间信息丢失**了，这对于语义分割所需要的精确位置来说是十分关键的。为了解决这个问题，我们在反卷积网络中使用反池化层，它进行池化的逆操作，并像图3所展示的那样重构至原始大小的图像。为了实施反池化操作，作者使用转换变量（switch variables）中记录了在池化操作时选择的最大像素的位置，并在反池化时将像素复原到其原来的位置。这种反池化策略在重建输入物体的结构时尤其有用。

* 反卷积

反池化层的输出大小扩大了，但仍然是**稀疏的映射**。反卷积层通过多层类似卷积的滤波，将由反池化层获得的稀疏图增加密度。然而，与将多个输入像素通过滤波窗口变成一个像素的卷积层不同，反卷积层将一个输入像素与多个输出相联系。反卷积层的输出是扩大而且变密的像素。我们将扩大的像素映射的边缘裁去，以保持输出大小和之前的反池化层一致。在反卷积层中学习的滤波是重建输入物体的形状的基础。因此，与卷积网络相似，反卷积层的层次结构被用来获取不同类的形状细节。底层的滤波倾向于获取一个物体的整体形状，特定类的精细细节被编码在高层滤波中。通过这种方式，网络直接在语义分割时考虑到了特定类的形状信息。

![](./image/5.png)

## 3. 复现论文


## 4. 完成对比实验


## 5. 形成报告


