#!/usr/bin/env python3
"""Basic STL quality audit for generated bumper artifacts."""
from __future__ import annotations

import struct
from pathlib import Path


def _triangle_stats(triangles):
    vertices = [v for tri in triangles for v in tri]
    if not vertices:
        raise ValueError("no triangles")
    degenerate = 0
    for tri in triangles:
        ax, ay, az = (tri[1][j] - tri[0][j] for j in range(3))
        bx, by, bz = (tri[2][j] - tri[0][j] for j in range(3))
        cross = (ay*bz-az*by, az*bx-ax*bz, ax*by-ay*bx)
        if sum(v*v for v in cross) < 1e-12:
            degenerate += 1
    mins = [min(v[j] for v in vertices) for j in range(3)]
    maxs = [max(v[j] for v in vertices) for j in range(3)]
    return len(triangles), mins, maxs, degenerate


def read_stl(path: Path):
    data = path.read_bytes()
    if len(data) >= 84:
        count = struct.unpack_from("<I", data, 80)[0]
        expected = 84 + count * 50
        if expected == len(data):
            triangles = []
            for i in range(count):
                offset = 84 + i * 50
                coords = struct.unpack_from("<12f", data, offset)
                triangles.append([coords[3:6], coords[6:9], coords[9:12]])
            return _triangle_stats(triangles)
    text = data.decode("utf-8", errors="ignore")
    triangles = []
    current = []
    for line in text.splitlines():
        parts = line.strip().split()
        if len(parts) == 4 and parts[0].lower() == "vertex":
            current.append(tuple(float(x) for x in parts[1:4]))
            if len(current) == 3:
                triangles.append(current)
                current = []
    if current:
        raise ValueError("incomplete ASCII STL triangle")
    return _triangle_stats(triangles)


def main() -> int:
    root = Path(__file__).resolve().parents[1]
    stl_dir = root / "build" / "stl"
    rows = []
    warnings = []
    for path in sorted(stl_dir.glob("*.stl")):
        count, mins, maxs, degenerate = read_stl(path)
        dims = [maxs[j] - mins[j] for j in range(3)]
        if any(d <= 1.0 or d > 200.0 for d in dims):
            raise AssertionError(f"{path.name}: unexpected dimensions {dims}")
        ratio = degenerate / count if count else 1.0
        if ratio > 0.01:
            raise AssertionError(f"{path.name}: {degenerate} degenerate triangles ({ratio:.2%})")
        if degenerate:
            warnings.append(f"{path.name}: {degenerate} collinear triangles ({ratio:.2%}); slicers normally ignore zero-area facets")
        rows.append((path.name, count, *dims, path.stat().st_size))
    if len(rows) != 5:
        raise AssertionError(f"expected 5 STL files, found {len(rows)}")
    print("name\ttriangles\tX_mm\tY_mm\tZ_mm\tbytes")
    for row in rows:
        print("\t".join(str(x) if isinstance(x, int) else f"{x:.3f}" if isinstance(x, float) else str(x) for x in row))
    if warnings:
        print("QUALITY WARNINGS")
        print("\n".join(f"- {warning}" for warning in warnings))
    print("STL AUDIT OK")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
