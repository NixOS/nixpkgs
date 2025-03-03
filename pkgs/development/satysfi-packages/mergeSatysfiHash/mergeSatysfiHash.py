#!/usr/bin/env python3

import sys
import re
import os

line_pattern = re.compile(
    r'^\s*"([^"]+)"\s*:\s*<(Single|Collection):\s*(\{.*\})\s*>(,?)\s*$'
)

def parse_hash_file(path: str) -> dict[str, tuple[str, str]]:
    mapping = {}
    if not os.path.exists(path):
        return mapping
    with open(path, "r", encoding="utf-8") as f:
        lines = f.read().splitlines()
    if len(lines) >= 1 and lines[0].strip() == "{":
        lines = lines[1:]
    if len(lines) >= 1 and lines[-1].strip() == "}":
        lines = lines[:-1]
    for line in lines:
        line = line.strip()
        if not line:
            continue
        m = line_pattern.match(line)
        if not m:
            continue
        key = m.group(1)
        typ = m.group(2)
        payload = m.group(3)
        mapping[key] = (typ, payload)
    return mapping

def write_hash_file(path: str, mapping: dict[str, tuple[str, str]]):
    items = list(mapping.items())
    with open(path, "w", encoding="utf-8") as f:
        f.write("{\n")
        for i, (key, (typ, payload)) in enumerate(items):
            comma = "," if i < len(items) - 1 else ""
            line = f'  "{key}" : <{typ}: {payload}>{comma}\n'
            f.write(line)
        f.write("}\n")

def merge_hash_files(old_file: str, new_file: str, out_file: str):
    old_map = parse_hash_file(old_file)
    new_map = parse_hash_file(new_file)
    old_map.update(new_map)
    write_hash_file(out_file, old_map)

def main():
    if len(sys.argv) < 4:
        print("Usage: mergeSatysfiHash OLD_FILE NEW_FILE OUT_FILE")
        sys.exit(1)
    old_file = sys.argv[1]
    new_file = sys.argv[2]
    out_file = sys.argv[3]
    merge_hash_files(old_file, new_file, out_file)

if __name__ == "__main__":
    main()

