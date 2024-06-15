# 软件安全理论与应用技术

## 实验环境

> 由于ModelScope实验平台并未提供Intel架构的显卡，所以使用平台提供的CPU环境进行实验。

+ Intel(R) Xeon(R) Platinum 8369B CPU @ 2.70GHz 8核 32GB
+ python环境为LabGuide中提供的`itrex` conda环境
+ 中文大模型为`ChatGLM3-6B`
+ [intel-extension-for-transformers](https://github.com/intel/intel-extension-for-transformers)

## 实验步骤

### 相关代码

+ [env.sh](./env.sh)：环境配置脚本
  + 可以完成conda环境配置、实验使用的大模型、embedding模型以及相关知识库的下载
  + `history_24`文件夹下为相关知识库，由于纯CPU向量化较慢，二十四史选择只保留《三国志》进行实验测试。
+ [history_bot.py](./history_bot.py)：中国历史问答应用主要文件
  + 包括Bot的搭建和聊天功能，使用`intel-extension-for-transformers`中的组件`Neural Chat`进行搭建。
  + 通过RAG来提高Bot的回复质量。

### 操作步骤

1. 启动ModelScope CPU实例（注意选择带tf版本的，不带tf版本可能没有预装conda）
2. 将`env.sh`和`history_bot.py`复制到`/mnt/workspace`
3. 运行`bash env.sh`完成实验环境配置，结束后使用`conda activate itrex`进入实验环境
4. 启动问答应用`python3 history_bot.py`

### 实验结果

#### 问答实验

可以看到bot可以给出合理且正确的回复，并从史料中提取相关的内容来提高回复的质量。不足之处在于`ChatGLM3-6B`的token数较少，没能给出更多的信息。

![Normal Answer](./figs/normal_answer.png)

但同时，也有一些提供错误信息的情况，例如：

![Wrong Answer](./figs/wrong_answer.png)

#### 攻击尝试

在与bot友好交流的同时，我也尝试进行了**简易**的提示词注入攻击，但是可以看到`ChatGLM3-6B`做了很好的alignment导致攻击失败：

![Attack Try](./figs/attack_try.png)

## 实验总结

通过本次实践，亲手在Intel的CPU上部署了中文大模型，也体会到了目前中文大模型的优秀。Intel Extension for Transformers不仅一定程度地加快了CPU平台上推理的速度，也提供了很多工具（例如neural chat）让搭建小型应用变得更加简单。

除此之外，这次的应用搭建让我感受到当今大模型在各种计算平台上的优化已经是大势所趋，也期待未来可以在中低算力平台上使用大模型。

尽管成功在CPU平台上部署并使用了大模型应用，但很容易感觉到计算时间/推理时间太久了。由于本次我更希望探索一些安全相关的小实验，所以并没有对应用部署以及推理时间进行优化。

## 一些思考

关于我在实验中的思考，我主要有两个方面：

1. 正如我在总结中所提到的，大模型在非GPU平台上的优化正在逐步发展，这可能让端上的模型计算或联邦学习场景下的使用成为可能。联邦学习场景下的隐私问题也是当下的一大热门话题，但结合我自身的研究方向与内容，我更关注各种平台尤其是移动端上的模型计算。如今有一些工作**尝试在端上部署一些模型来对网页内容进行过滤或恶意内容检测**，目前这些模型也都相对较小。但这次的实验让我觉得，在未来，在端上计算能力逐步增强的同时，模型社区对非GPU平台上计算的优化，可以让端上使用较大规模的模型成为了可能。
2. 大模型的安全我觉得主要有两种保护方式，一种是alignment，一种是使用外部的sanitizer。我在应用部署之余，尝试对大模型进行简单的提示词注入攻击。由于我的攻击方式较为简单，加上如今的大模型alignment做的都很好，导致这种简易攻击已经无法生效。但我依然认为大模型是没有较为通用且强硬的防御方式，在对一个模型了解的情况下一定可以找到某一种方式来进行攻击，**问题在于如何获取模型信息与通过数学理论推演得到攻击范式**。这一年来，LLM除了不断更新发展自身的安全性，各平台也是用sanitizer来进行安全防护。alignment本身带来的安全性，加上开发者是用sanitizer提供的一定程度的数据安全性，可以很好的保护大模型。**在这种情况下，如何发现新的攻击面，将是一个有趣的话题**。

## 相关参考文献

+ [Universal and Transferable Adversarial Attacks on Aligned Language Models](https://arxiv.org/abs/2307.15043)
+ [PLeak: Prompt Leaking Attacks against Large Language Model Applications](https://arxiv.org/abs/2405.06823)
+ [Attacks, Defenses and Evaluations for LLM Conversation Safety: A Survey](https://arxiv.org/abs/2402.09283)
+ [Detoxifying Large Language Models via Knowledge Editing](https://arxiv.org/abs/2403.14472)
+ [GreenLLaMA: A Framework for Detoxification with Explanations](https://arxiv.org/abs/2402.15951)