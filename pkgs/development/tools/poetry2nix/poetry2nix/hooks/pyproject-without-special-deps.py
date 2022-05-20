#!/usr/bin/env python
# Patch out special dependencies (git and path) from a pyproject.toml file

import argparse
import sys

import tomlkit


def main(input, output, fields_to_remove):
    data = tomlkit.loads(input.read())

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

    output.write(tomlkit.dumps(data))


if __name__ == "__main__":
    p = argparse.ArgumentParser()
    p.add_argument(
        "-i",
        "--input",
        type=argparse.FileType("r"),
        default=sys.stdin,
        help="Location from which to read input TOML",
    )
    p.add_argument(
        "-o",
        "--output",
        type=argparse.FileType("w"),
        default=sys.stdout,
        help="Location to write output TOML",
    )
    p.add_argument(
        "-f",
        "--fields-to-remove",
        nargs="+",
        help="The fields to remove from the dependency's TOML",
    )

    args = p.parse_args()
    main(args.input, args.output, args.fields_to_remove)
