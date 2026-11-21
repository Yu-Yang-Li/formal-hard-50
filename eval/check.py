"""FH50 判分：python3 check.py FH50-021 Solution.lean [--verdict prove|disprove]

按题目来源选择 Lean 环境，构造 Challenge，再用 Comparator 核对定理陈述未改动、
只用 propext / Quot.sound / Classical.choice 三条公理，并由 Lean 内核接受。
判分规则与 MathArena ArXivLean、Epoch LeanOpenProblems 的原评测一致。
"""
import argparse, fcntl, json, os, re, subprocess, sys

HERE = os.path.dirname(os.path.abspath(__file__))
PKG = os.path.dirname(HERE)
ENVIRONMENTS = {
    ('ArXivLean', '0326'): ('lean429', '4.29.0'),
    ('ArXivLean', '0626'): ('lean431', '4.31.0'),
    ('ArXivLean', '0926'): ('lean4341', '4.34.1'),
    ('OEIS Open', 'Lite'): ('fc_oeis', '4.27.0'),
    ('FrontierMath Erdős', 'bloom68'): ('fc_erdos', '4.33.1'),
}
AXIOMS = ['propext', 'Quot.sound', 'Classical.choice']
JUDGE_LIB_LEAN = '\nlean_lib FH50Judge where\n  globs := #[.submodules `FH50Judge]\n'
JUDGE_LIB_TOML = '\n[[lean_lib]]\nname = "FH50Judge"\nglobs = ["FH50Judge.+"]\n'


def strip_imports(text):
    return '\n'.join(line for line in text.splitlines() if not line.strip().startswith('import '))


def declared(text, name):
    """返回名为 name 的 theorem 是否给出了非 sorry 的证明。"""
    match = re.search(r'(?m)^\s*theorem\s+' + re.escape(name) + r'\b(.*?)(?=^\S|\Z)', text, re.S)
    return bool(match) and not re.fullmatch(r'(?s).*:=\s*(by\s+)?sorry\s*', match.group(0).strip())


def build_challenge(case, statement, solution, verdict):
    if case['task'] == 'prove':
        theorem = re.search(r'(?m)^(?:theorem|lemma)\s+(\S+)', statement).group(1)
        return 'import Mathlib\n\n' + strip_imports(statement).strip() + '\n', 'import Mathlib\n\n' + strip_imports(solution).strip() + '\n', theorem, 'prove'
    if case['source'] == 'ArXivLean':
        names = {'prove': 'arxivlean_proof', 'disprove': 'arxivlean_disproof'}
        if verdict is None:
            found = [v for v, n in names.items() if re.search(r'(?m)^\s*theorem\s+' + n + r'\s*:', solution)]
            if len(found) != 1:
                sys.exit('作答里必须恰好声明 arxivlean_proof 或 arxivlean_disproof 之一')
            verdict = found[0]
        target = 'arxivleanConjecture' if verdict == 'prove' else 'Not arxivleanConjecture'
        challenge = 'import Mathlib\n\n' + strip_imports(statement).strip() + f'\n\ntheorem {names[verdict]} : {target} := by\n  sorry\n'
        return challenge, 'import Mathlib\n\n' + strip_imports(solution).strip() + '\n', names[verdict], verdict
    main = re.search(r'(?m)^theorem\s+(\S+)\.disproof\s*:', statement).group(1)
    if verdict is None:
        verdict = 'disprove' if declared(solution, main + '.disproof') or declared(solution, main.split('.')[-1] + '.disproof') else 'prove'
    return statement, solution, main if verdict == 'prove' else main + '.disproof', verdict


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('case_id')
    parser.add_argument('solution')
    parser.add_argument('--verdict', choices=['prove', 'disprove'])
    parser.add_argument('--root', default=os.environ.get('FH50_ROOT', os.path.expanduser('~/fh50')), help='setup_envs.sh 和 setup_tools.sh 的安装目录')
    args = parser.parse_args()

    cases = {c['id']: c for c in (json.loads(l) for l in open(os.path.join(PKG, 'cases.jsonl'), encoding='utf-8'))}
    case = cases[args.case_id]
    env_name, lean_version = ENVIRONMENTS[(case['source'], case['edition'])]
    env_dir = os.path.join(args.root, env_name)
    tools = os.path.join(args.root, 'tools')
    statement = open(os.path.join(PKG, case['statement_file']), encoding='utf-8').read()
    solution = open(args.solution, encoding='utf-8').read()
    challenge, solution_file, theorem, verdict = build_challenge(case, statement, solution, args.verdict)

    module = args.case_id.replace('-', '_')
    with open(os.path.join(env_dir, '.fh50judge.lock'), 'w') as lock:
        fcntl.flock(lock, fcntl.LOCK_EX)
        lakefile = os.path.join(env_dir, 'lakefile.lean')
        if os.path.exists(lakefile):
            text, extra = open(lakefile).read(), JUDGE_LIB_LEAN
        else:
            lakefile = os.path.join(env_dir, 'lakefile.toml')
            text, extra = open(lakefile).read(), JUDGE_LIB_TOML
        if 'FH50Judge' not in text:
            open(lakefile, 'a').write(extra)
        work = os.path.join(env_dir, 'FH50Judge', module)
        os.makedirs(work, exist_ok=True)
        open(os.path.join(work, 'Challenge.lean'), 'w', encoding='utf-8').write(challenge)
        open(os.path.join(work, 'Solution.lean'), 'w', encoding='utf-8').write(solution_file)
        config = os.path.join(work, 'comparator.json')
        json.dump(dict(challenge_module=f'FH50Judge.{module}.Challenge', solution_module=f'FH50Judge.{module}.Solution',
                       theorem_names=[theorem], permitted_axioms=AXIOMS, enable_nanoda=False), open(config, 'w'))
        env = dict(os.environ)
        env['PATH'] = ':'.join([os.path.join(tools, 'landrun', 'bin'),
                                os.path.join(tools, f'lean4export-{lean_version}', '.lake', 'build', 'bin'),
                                os.path.expanduser(f'~/.elan/toolchains/leanprover--lean4---v{lean_version}/bin'),
                                os.path.expanduser('~/.elan/bin'), env['PATH']])
        comparator = os.path.join(tools, f'comparator-{lean_version}', '.lake', 'build', 'bin', 'comparator')
        result = subprocess.run(['lake', 'env', comparator, config], cwd=env_dir, env=env, capture_output=True, text=True)
    log = result.stdout + result.stderr
    report = dict(id=args.case_id, verdict=verdict, theorem=theorem, accepted=result.returncode == 0, log_tail=log[-1500:])
    print(json.dumps(report, ensure_ascii=False))
    sys.exit(0 if report['accepted'] else 1)


if __name__ == '__main__':
    main()

