import os
import sys

import r2pipe


class Asm:
    def __init__(self, *insns):
        self.insns = insns


def asm(*insns):
    return Asm(*insns)


def hx(s):
    return bytes.fromhex(s)


def patch_file(path, hunks):
    r2 = r2pipe.open(
        path,
        flags=[
            "-N",  # do not load user settings and scripts
            "-n",  # treat the file as raw binary, offsets are file offsets
            "-w",  # open read-write
            "-a",
            "x86",
            "-b",
            "64",
            "-e",
            "scr.interactive=false",
        ],
    )

    def resolve(value, off):
        if isinstance(value, Asm):
            # Assemble at the hunk's file offset, so position-dependent
            # encodings (e.g. relative branches) come out as in the binary.
            return b"".join(
                bytes.fromhex(r2.cmd(f"pa {insn} @ {off}").strip())
                for insn in value.insns
            )
        return value

    resolved = [(off, resolve(old, off), resolve(new, off)) for off, old, new in hunks]

    for off, old, new in resolved:
        if len(old) != len(new):
            raise SystemExit(
                f"{path} @ {off:#x}: length mismatch: {len(old)} != {len(new)}"
            )

    for off, old, _ in resolved:
        cur = bytes.fromhex(r2.cmd(f"p8 {len(old)} @ {off}").strip())
        if cur != old:
            raise SystemExit(
                f"{path} @ {off:#x}: expected {old.hex()}, found {cur.hex()}"
            )

    for off, _, new in resolved:
        r2.cmd(f"wx {new.hex()} @ {off}")

    for off, _, new in resolved:
        cur = bytes.fromhex(r2.cmd(f"p8 {len(new)} @ {off}").strip())
        if cur != new:
            raise SystemExit(
                f"{path} @ {off:#x}: write of {new.hex()} failed, found {cur.hex()}"
            )

    r2.quit()


def main():
    if len(sys.argv) != 3:
        raise SystemExit(f"usage: {sys.argv[0]} <patches-file.py> <directory>")
    namespace = {"asm": asm, "hx": hx}
    with open(sys.argv[1]) as f:
        exec(compile(f.read(), sys.argv[1], "exec"), namespace)
    for relpath, hunks in namespace["HUNKS"].items():
        patch_file(os.path.join(sys.argv[2], relpath), hunks)


if __name__ == "__main__":
    main()
