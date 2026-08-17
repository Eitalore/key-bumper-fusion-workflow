#!/usr/bin/env python3
from __future__ import annotations
from pathlib import Path

path = Path(__file__).resolve().parents[1] / 'build/stl/geely_ex2_bumper_bosl2_v01.stl'
text = path.read_text(encoding='utf-8', errors='ignore')
triangles = []
current = []
for line in text.splitlines():
    parts = line.strip().split()
    if len(parts) == 4 and parts[0].lower() == 'vertex':
        current.append(tuple(float(x) for x in parts[1:4]))
        if len(current) == 3:
            triangles.append(current)
            current = []
found = 0
for i, tri in enumerate(triangles):
    ax, ay, az = (tri[1][j] - tri[0][j] for j in range(3))
    bx, by, bz = (tri[2][j] - tri[0][j] for j in range(3))
    cross = (ay*bz-az*by, az*bx-ax*bz, ax*by-ay*bx)
    area2 = sum(v*v for v in cross)
    if area2 < 1e-12:
        print(f'triangle={i} area2={area2:.3e} vertices={tri}')
        found += 1
print(f'degenerate_count={found} total={len(triangles)}')
