"""把 50 个题面在各自的 Lean 环境里编译一遍，确认环境可用；只应出现 sorry 警告。"""
import json, os, subprocess, sys
from concurrent.futures import ThreadPoolExecutor
PKG = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
HOME = os.environ.get('FH50_ROOT', os.path.expanduser('~/fh50'))
RES = HOME + '/results/compile.jsonl'
os.makedirs(HOME + '/results', exist_ok=True)
ENV = {('ArXivLean', '0326'): 'lean429', ('ArXivLean', '0626'): 'lean431', ('ArXivLean', '0926'): 'lean4341',
       ('OEIS Open', 'Lite'): 'fc_oeis', ('FrontierMath Erdős', 'bloom68'): 'fc_erdos'}
cases = [json.loads(l) for l in open(PKG + '/cases.jsonl', encoding='utf-8')]
done = {}
if os.path.exists(RES):
    for l in open(RES, encoding='utf-8'):
        r = json.loads(l); done[r['id']] = r
os.environ['PATH'] = os.path.expanduser('~/.elan/bin') + ':' + os.environ['PATH']

def run(c):
    env = ENV[(c['source'], c['edition'])]
    src = PKG + '/' + c['statement_file']
    dst = f"{HOME}/{env}/FH50Check/{c['id'].replace('-', '_')}.lean"
    os.makedirs(os.path.dirname(dst), exist_ok=True)
    open(dst, 'w', encoding='utf-8').write(open(src, encoding='utf-8').read())
    p = subprocess.run(['lake', 'env', 'lean', dst], cwd=f'{HOME}/{env}', capture_output=True, text=True, timeout=3600)
    out = p.stdout + p.stderr
    errors = [l for l in out.splitlines() if ': error' in l]
    return dict(id=c['id'], env=env, returncode=p.returncode, errors=errors[:5], sorry_warnings=out.count("declaration uses 'sorry'"), ok=(p.returncode == 0 and not errors))

todo = [c for c in cases if not done.get(c['id'], {}).get('ok') and (len(sys.argv) < 3 or c['id'] in sys.argv[2].split(','))]
with ThreadPoolExecutor(int(sys.argv[1]) if len(sys.argv) > 1 else 6) as ex:
    for r in ex.map(run, todo):
        done[r['id']] = r
        with open(RES, 'a', encoding='utf-8') as f: f.write(json.dumps(r, ensure_ascii=False) + '\n')
        print(r['id'], r['env'], 'OK' if r['ok'] else 'FAIL', r['errors'][:2], flush=True)
print('compiled ok', sum(1 for r in done.values() if r.get('ok')), 'of', len(cases))

