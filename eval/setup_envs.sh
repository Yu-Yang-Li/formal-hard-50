#!/usr/bin/env bash
# 搭建 FH50 的 5 套 Lean 环境，可重复执行，已完成的环境会跳过
set -euo pipefail
ROOT=${FH50_ROOT:-$HOME/fh50}
mkdir -p "$ROOT/logs"
export PATH=$HOME/.elan/bin:$PATH
if [ ! -x "$HOME/.elan/bin/elan" ]; then
  curl -sSfL https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh -o /tmp/elan-init.sh
  sh /tmp/elan-init.sh -y --default-toolchain none
fi

retry() {
  for attempt in 1 2 3 4 5 6; do
    if "$@"; then return 0; fi
    echo "retry $attempt: $*"; sleep 10
  done
  return 1
}

mk_mathlib() {
  name=$1; toolchain=$2; rev=$3
  d=$ROOT/$name
  if [ -f "$d/.done" ]; then echo "$name ready"; return; fi
  mkdir -p "$d"; cd "$d"
  echo "leanprover/lean4:$toolchain" > lean-toolchain
  if [ ! -f lakefile.lean ]; then
    printf '%s\n' 'import Lake' 'open Lake DSL' 'package fh50 where' 'require mathlib from git' "  \"https://github.com/leanprover-community/mathlib4\" @ \"$rev\"" > lakefile.lean
  fi
  [ -f lake-manifest.json ] && [ -d .lake/packages/mathlib ] || retry lake update
  retry lake exe cache get
  printf '%s\n' 'import Mathlib' 'example : True := trivial' > Smoke.lean
  lake env lean Smoke.lean
  touch .done; echo "$name done"
}

mk_fc() {
  name=$1; commit=$2; module=$3
  d=$ROOT/$name
  if [ -f "$d/.done" ]; then echo "$name ready"; return; fi
  [ -d "$d/.git" ] || retry git clone --filter=blob:none https://github.com/google-deepmind/formal-conjectures "$d"
  cd "$d"; git checkout -q "$commit"
  retry lake exe cache get
  lake build "$module"
  touch .done; echo "$name done"
}

# 逐套执行：Mathlib 缓存下载共用 ~/.cache/mathlib，并行会互相覆盖临时文件
mk_mathlib lean429 v4.29.0 v4.29.0 >> "$ROOT/logs/lean429.log" 2>&1 || echo 'lean429 FAILED'
mk_mathlib lean431 v4.31.0 v4.31.0 >> "$ROOT/logs/lean431.log" 2>&1 || echo 'lean431 FAILED'
mk_mathlib lean4341 v4.34.1 d13f23b723b8a846827a245b89c10fc7d3f11612 >> "$ROOT/logs/lean4341.log" 2>&1 || echo 'lean4341 FAILED'
mk_fc fc_oeis 67338a1 FormalConjectures.Util.ProblemImports >> "$ROOT/logs/fc_oeis.log" 2>&1 || echo 'fc_oeis FAILED'
mk_fc fc_erdos f5f23b4 FormalConjecturesUtil >> "$ROOT/logs/fc_erdos.log" 2>&1 || echo 'fc_erdos FAILED'
for n in lean429 lean431 lean4341 fc_oeis fc_erdos; do
  if [ -f "$ROOT/$n/.done" ]; then echo "$n OK"; else echo "$n FAILED"; fi
done

