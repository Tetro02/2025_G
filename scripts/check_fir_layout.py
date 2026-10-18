"""Validate the current FIR coefficient and reload layout against saved IP output."""
from pathlib import Path
import re
ROOT = Path(__file__).resolve().parents[1]
source = (ROOT / 'hello_world/src/helloworld.c').read_text(encoding='utf-8')
match = re.search(r'reload_map\[1008\]\s*=\s*\{(.*?)\};', source, re.S)
indices = [int(n) for n in re.findall(r'-?\d+', match[1])]
reference = (ROOT / 'docs/fir_compiler_0_reload_order.txt').read_text()
expected = [int(n) for n in re.findall(r'Coefficient (\d+)', reference)]
assert indices == expected, 'C map differs from IP reload order'
assert sorted(indices) == list(range(1008)), 'Unexpected or duplicated reload positions'
assert sum(i >= 1001 for i in indices) == 7
text = (ROOT / 'coefficients/20000D_1M_1000.coe').read_text()
coeffs = re.findall(r'\b[0-9a-fA-F]+\b', text.split('CoefData =', 1)[1])
assert len(coeffs) == 1001, 'Initial coefficient count mismatch'
print('FIR layout: 1001 taps, 1008 reload words, 7 padding positions; saved IP map matches.')
