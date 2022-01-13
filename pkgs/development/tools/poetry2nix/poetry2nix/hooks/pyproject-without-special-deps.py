#!/usr/bin/env python
# Patch out special dependencies (git and path) from a pyproject.json file

import argparse
import json
import sys


def main(input, output, fields_to_remove):
    data = json.load(input)

    try:
        deps = data["tool"]["poetry"]["dependencies"]
    except KeyError:
        pass
    else:
        for dep in deps.values():
            if isinstance(dep, dict):
                any_removed = False
                for field in fields_to_remove:
                    any_removed |= dep.pop(field, None) is not None
                if any_removed:
                    dep["version"] = "*"

    # Set ensure_ascii to False because TOML is valid UTF-8 so text that can't
    # be represented in ASCII is perfectly legitimate
    # HACK: Setting ensure_asscii to False breaks Python2 for some dependencies (like cachy==0.3.0)
    json.dump(
        data, output, separators=(",", ":"), ensure_ascii=sys.version_info.major < 3
    )


if __name__ == "__main__":
    p = argparse.ArgumentParser()
    p.add_argument(
        "-i",
        "--input",
        type=argparse.FileType("r"),
        default=sys.stdin,
        help="Location from which to read input JSON",
    )
    p.add_argument(
        "-o",
        "--output",
        type=argparse.FileType("w"),
        default=sys.stdout,
        help="Location to write output JSON",
    )
    p.add_argument(
        "-f",
        "--fields-to-remove",
        nargs="+",
        help="The fields to remove from the dependency's JSON",
    )

    args = p.parse_args()
    main(args.input, args.output, args.fields_to_remove)
