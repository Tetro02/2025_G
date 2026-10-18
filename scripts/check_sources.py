"""Check source dependencies without requiring Vivado or an FPGA."""
from pathlib import Path
import json
import re
import xml.etree.ElementTree as ET
ROOT = Path(__file__).resolve().parents[1]
errors = []
count = 0
for xpr in sorted(ROOT.rglob('*.xpr')):
    if any(p.endswith(('.gen','.runs','.cache')) for p in xpr.parts):
        continue
    name = xpr.stem
    for elem in ET.parse(xpr).findall('.//File'):
        value = elem.get('Path', '')
        if not value or '$PGENDIR' in value:
            continue
        value = value.replace('$PPRDIR', str(xpr.parent)).replace('$PSRCDIR', str(xpr.parent / (name + '.srcs')))
        count += 1
        target = Path(value).resolve()
        if not target.is_relative_to(ROOT):
            errors.append(f'Outside repository: {xpr.relative_to(ROOT)}: {value}')
        elif not target.is_file():
            errors.append(f'Missing source: {target.relative_to(ROOT)}')
for xci in ROOT.rglob('*.xci'):
    if not any(p.endswith('.srcs') for p in xci.parts):
        continue
    data = json.loads(xci.read_text(encoding='utf-8-sig'))
    params = data['ip_inst']['parameters']['component_parameters']
    for key in ('Coe_File', 'Coefficient_File'):
        for item in params.get(key, []):
            value = item['value']
            if value in ('no_coe_file_loaded', '') or item.get('enabled') is False:
                continue
            count += 1
            target = (xci.parent / value).resolve()
            if not target.is_relative_to(ROOT) or not target.is_file():
                errors.append(f'Missing/outside COE: {xci.relative_to(ROOT)}: {value}')
xml = ROOT / 'ip_repo/AXI_Lite_PS_To_PL_PL_1_0/component.xml'
ns = {'s': 'http://www.spiritconsortium.org/XMLSchema/SPIRIT/1685-2009'}
for elem in ET.parse(xml).findall('.//s:file/s:name', ns):
    count += 1
    if not (xml.parent / elem.text).is_file():
        errors.append(f'Missing IP component file: {elem.text}')
for msg in errors:
    print('FAIL:', msg)
print(f'Checked {count} dependency references; {len(errors)} error(s).')
raise SystemExit(bool(errors))
