# 形式化证明难题 50 道（FH50）

从还没被刷满的形式化题库里，按别人公开的逐题作答记录挑出的 50 道最难题。全部是 Lean 4 + Mathlib 定理，作答方提交完整证明（部分题可以提交否证），由 Lean 编译和 Comparator 判定。

## 题从哪来

只用同时公开了失败记录的来源，也就是每个模型对每道题的通过或失败都能查到：

- **ArXivLean**（MathArena，2026 年 3、6、9 月三期，共 140 题）。题目来自当月 arXiv 新论文的定理。逐题结果取自 MathArena 官网 11 月 21 日的数据，包含 GPT-6.2 Astra、Gemini 4 Carbon 等最新模型；原始输出在 Hugging Face 公开。
- **OEIS Open 精简版**（Epoch AI，100 个 OEIS 猜想）。15 组运行加 4 组完整集运行，逐题结果取自 Epoch 的 LeanOpenProblems-results 仓库。
- **FrontierMath Erdős**（Epoch AI，68 个 Erdős 问题）。16 个模型的正式评测；其中 13 个模型的逐题结果可从公开运行和总分推出，GPT-6.2 Astra（7 题）、Gemini 4 Carbon（2 题）、Gemini 4 Argon（1 题）只公布了总分。

lean-eval 没有采用：它只公开通过记录，1,579 次提交里只有 357 条失败；剩下没人解出的多是费马大定理、开普勒猜想这类项目级形式化。

## 怎么判定“最难”

1. 至少 9 次独立作答，来自至少 3 家厂商。
2. 解出次数不超过作答次数的 20%。
3. 能确认题目有解：A 类要求同一条 Lean 陈述已有被 Comparator 接受的证明或否证；B 类没有任何系统解出，真假由已发表的证明确定。
4. 去掉同一猜想的重复版本、评测时作答的陈述与现行版本不一致的题，以及已被否证、说明形式化本身写错的题。

| 类别 | 来源 | 题数 |
|---|---|---:|
| A | ArXivLean（3 月 7、6 月 13、9 月 7） | 27 |
| A | OEIS Open 精简版 | 12 |
| B | FrontierMath Erdős | 7 |
| B | ArXivLean 6 月（14 个模型全部失败） | 4 |

A 类每题被 1 到 3 个系统解出：ArXivLean 3 月 1/10，6 月 1–2/14，9 月 1–2/10；OEIS 1–3/18–19。B 类在已知记录中全部失败：FrontierMath 的 7 题由 13 个已知结果的模型全部失败，ArXivLean 6 月的 4 题由 9 家厂商的 14 个模型全部失败。

## 文件

- [cases.jsonl](cases.jsonl)：每行一道题，含编号、类别、来源、任务（证明或证明否证）、Lean 环境、自然语言题面、Lean 文件路径和 SHA-256、许可、来源链接、作答统计。
- [problems/](problems/)：50 个 Lean 陈述文件，证明处为 sorry。OEIS 和 Erdős 的文件同时给出否证目标 `<名字>.disproof`，二者证出其一即可。
- [选题清单.md](选题清单.md)：逐题列出作答次数、解出者和备注。
- [evidence.jsonl](evidence.jsonl)：717 条逐次作答记录，每条注明模型、厂商、通过或失败、来源。
- [candidates.jsonl](candidates.jsonl)：259 条候选记录，每条写明入选或未入选的原因。
- [split.json](split.json)：固定的 25 道 Train 和 25 道 Test，按类别与来源分层。
- [eval/](eval/)：环境安装、题面编译和判分脚本，以及发布前的验证记录。
- [来源与许可.md](来源与许可.md)。

## 怎么评测

在 Linux 或 WSL 2 下运行，需要 git、curl、python3 和约 65 GB 磁盘（5 套环境、Lean 工具链和缓存实测共 62 GB）。环境默认装在 `~/fh50`，可用环境变量 `FH50_ROOT` 改位置。两个安装脚本都能重复执行，网络中断后重跑会从断点接上。

```bash
bash eval/setup_envs.sh            # 5 套 Lean 环境与 Mathlib 缓存
bash eval/setup_tools.sh           # Comparator、lean4export、landrun
python3 eval/compile_statements.py # 可选：确认 50 个题面都能编译
python3 eval/check.py FH50-021 Solution.lean
```

| 题目 | 环境 |
|---|---|
| ArXivLean 3 月 | Lean 4.29.0 + Mathlib v4.29.0 |
| ArXivLean 6 月 | Lean 4.31.0 + Mathlib v4.31.0 |
| ArXivLean 9 月 | Lean 4.34.1 + Mathlib d13f23b |
| OEIS Open | Lean 4.27.0 + formal-conjectures@67338a1 |
| FrontierMath Erdős | Lean 4.33.1 + formal-conjectures@f5f23b4 |

作答的写法沿用原评测。ArXivLean 3、6 月的题交一段完整的 Lean 代码，可以带辅助引理，结尾是与题面一字不差的主定理。9 月的题保留题面里的定义，再二选一声明 `theorem arxivlean_proof : arxivleanConjecture` 或 `theorem arxivlean_disproof : Not arxivleanConjecture`。OEIS 和 Erdős 的题在原文件上给主定理或 `<名字>.disproof` 之一写出证明。`check.py` 会自动识别交的是证明还是否证，也可以用 `--verdict` 指定。

`check.py` 按 MathArena 和 Epoch 原评测的方式构造 Challenge，再调用 Lean FRO 的 Comparator。只有定理陈述未改、只用 propext、Quot.sound、Classical.choice 三条公理、并被 Lean 内核接受的证明才算通过。ArXivLean 3、6 月的原始陈述不含文件头，MathArena 判分时会在前面加一行 import Mathlib，本包的文件已按同样方式补上。

发布前我们在这套环境里做了三项检查，记录在 [eval/verification.jsonl](eval/verification.jsonl) 和 [eval/compile_statements.jsonl](eval/compile_statements.jsonl)。50 个题面全部编译通过，只有 sorry 警告。从别人公开的通过证明里抽查了 9 份，覆盖 3 月、6 月和 OEIS 三套环境，全部被 `check.py` 接受。每套环境各试了一份作弊提交，分别是留 sorry、把定理改成 True 和另加公理，5 份全部被拒绝。

按题号、轮次保存作答和判分，跑断后从缺失的记录接上。


## 限制

- 题目都是近期论文或刚解决的猜想，证明已经公开，后续模型可能见过，需要按模型发布时间解读成绩。
- B 类没有机器验证过的、针对这份陈述的证明：FrontierMath #172、#821 只有 OpenAI 的论文，其余 5 题的 Lean 证明针对的是 OpenAI 自己的 Comparator 陈述；ArXivLean 6 月的 4 题依据原论文，并逐条人工核对了形式化。
- ArXivLean 6 月的 4 道 B 类题来自 2026 年 6 月的新预印本，尚未见同行评审。其中 Goldbach (1+1.9) 的原证明长达 66 页，Pinwheel 密度阈值的证明依赖计算机搜索，在 Lean 中完成的工作量很大。
- MathArena 的 arxivlean-0326 数据集里，source 和 title 两列从第 6 题起与题面错位。本包的 arXiv 编号按逐题输出记录 arxivlean-0326_outputs 修正，标题再按编号回查。
- FrontierMath 有 3 个模型只公布了总分，最坏情况下 B 类中某题可能被 3/16 解出，仍低于 20%。
- 39 道 A 类题里，ArXivLean 3、6 月的 20 道在 MathArena 的 Hugging Face 输出中有完整的通过证明，OEIS 的 12 道在 Epoch 的运行记录中也有。作答时必须关闭联网搜索，比较成绩时也要考虑模型训练时见过这些证明的可能。
