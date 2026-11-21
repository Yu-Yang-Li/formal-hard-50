#!/usr/bin/env bash
# 编译判分工具：landrun、各 Lean 版本对应的 Comparator 与 lean4export，可重复执行
set -euo pipefail
TOOLS=${FH50_ROOT:-$HOME/fh50}/tools
mkdir -p "$TOOLS"
export PATH=$HOME/.elan/bin:$TOOLS/go/bin:$PATH
if [ ! -x "$TOOLS/go/bin/go" ]; then
  curl -sSfL https://go.dev/dl/go1.24.5.linux-amd64.tar.gz | tar -xz -C "$TOOLS"
fi
if [ ! -x "$TOOLS/landrun/bin/landrun" ]; then
  [ -d "$TOOLS/landrun/src/.git" ] || git clone -q https://github.com/Zouuup/landrun.git "$TOOLS/landrun/src"
  git -C "$TOOLS/landrun/src" checkout -q --detach 811cfff51ceaf3d9843708aa6d22e9b84ccac8b4
  mkdir -p "$TOOLS/landrun/bin"
  (cd "$TOOLS/landrun/src" && go build -o "$TOOLS/landrun/bin/landrun" ./cmd/landrun)
fi
# 项目 Lean 版本:Comparator 标签:lean4export 标签。lean4export 必须用项目自己的 Lean 版本编译
# 4.27.0 的 Comparator 自带旧版导出解析器，读不了同版本 lean4export 的输出；按 Epoch 的做法改用 v4.34.0 的 Comparator
for triple in 4.27.0:4.34.0:4.27.0 4.29.0:4.29.0:4.29.0 4.31.0:4.31.0:4.31.0 4.33.1:4.33.0:4.33.0 4.34.1:4.34.0:4.34.0; do
  V=${triple%%:*}; rest=${triple#*:}; CMP_TAG=${rest%%:*}; EXPORT_TAG=${rest#*:}
  c=$TOOLS/comparator-$V
  if [ ! -f "$c/.done" ]; then
    [ -d "$c/.git" ] || git clone -q https://github.com/leanprover/comparator "$c"
    git -C "$c" checkout -q "v$CMP_TAG"
    if ! grep -Fq 'args ++ #["--", spawnArgs.cmd]' "$c/Main.lean"; then
      git -C "$c" fetch -q origin 9badaf470d8f724346d33738bd273efacd78df76
      git -C "$c" show --format= 9badaf470d8f724346d33738bd273efacd78df76 -- Main.lean | git -C "$c" apply -
    fi
    (cd "$c" && lake build)
    touch "$c/.done"
  fi
  e=$TOOLS/lean4export-$V
  if [ ! -f "$e/.done" ]; then
    [ -d "$e/.git" ] || git clone -q https://github.com/leanprover/lean4export "$e"
    git -C "$e" checkout -q "v$EXPORT_TAG"
    echo "leanprover/lean4:v$V" > "$e/lean-toolchain"
    (cd "$e" && lake build)
    touch "$e/.done"
  fi
done
ls "$TOOLS"/comparator-*/.lake/build/bin "$TOOLS"/lean4export-*/.lake/build/bin "$TOOLS/landrun/bin"
echo TOOLS_OK

