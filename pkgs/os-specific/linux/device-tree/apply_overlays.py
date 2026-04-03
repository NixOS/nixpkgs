from argparse import ArgumentParser
from dataclasses import dataclass
from functools import cached_property
import json
from pathlib import Path
import shutil
import subprocess
import os

from libfdt import Fdt, FdtException, FDT_ERR_NOTFOUND


@dataclass
class Overlay:
    name: str
    filter: str
    dtbo_file: Path

    @cached_property
    def fdt(self) -> Fdt:
        with self.dtbo_file.open("rb") as fd:
            return Fdt(fd.read())

    @cached_property
    def compatible(self) -> set[str]:
        return get_compatible(self.fdt)


def get_compatible(fdt) -> set[str]:
    root_offset = fdt.path_offset("/")

    try:
        return set(fdt.getprop(root_offset, "compatible").as_stringlist())
    except FdtException as e:
        if e.err == -FDT_ERR_NOTFOUND:
            return set()
        else:
            raise e

def apply_overlay(base: Path, dtbo: Path):
    temp = base.with_suffix(".tmp")
    subprocess.check_call(["ufdt_apply_overlay", base, dtbo, temp])
    os.replace(temp, base)


def process_dtb(rel_path: Path, source: Path, destination: Path, overlays_data: list[Overlay]):
    source_dt = source / rel_path
    dest_path = destination / rel_path
    dest_path.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy(source / rel_path, dest_path)

    print(f"Processing source device tree {rel_path}...")

    for overlay in overlays_data:
        if overlay.filter and overlay.filter not in str(rel_path):
            print(f"  Skipping overlay {overlay.name}: filter does not match")
            continue

        with dest_path.open("rb") as fd:
            dt = Fdt(fd.read())
        dt_compatible = get_compatible(dt)
        if len(dt_compatible) == 0:
            print(f"  Device tree {rel_path} has no compatible string set. Assuming it's compatible with overlay")
        elif not overlay.compatible.intersection(dt_compatible):
            print(f"  Skipping overlay {overlay.name}: {overlay.compatible} is incompatible with {dt_compatible}")
            continue

        print(f"  Applying overlay {overlay.name}")
        apply_overlay(dest_path, overlay.dtbo_file)

def main():
    parser = ArgumentParser(description='Apply a list of overlays to a directory of device trees')
    parser.add_argument("--source", type=Path, help="Source directory")
    parser.add_argument("--destination", type=Path, help="Destination directory")
    parser.add_argument("--overlays", type=Path, help="JSON file with overlay descriptions")
    args = parser.parse_args()

    source: Path = args.source
    destination: Path = args.destination
    overlays: Path = args.overlays

    with overlays.open() as fd:
        overlays_data = [
            Overlay(
                name=item["name"],
                filter=item["filter"],
                dtbo_file=Path(item["dtboFile"]),
            )
            for item in json.load(fd)
        ]

    for dirpath, dirnames, filenames in source.walk():
        for filename in filenames:
            rel_path = (dirpath / filename).relative_to(source)
            if filename.endswith(".dtb"):
                process_dtb(rel_path, source, destination, overlays_data)
            else:
                # Copy other files through
                dest_path = destination / rel_path
                dest_path.parent.mkdir(parents=True, exist_ok=True)
                shutil.copy(source / rel_path, dest_path)


if __name__ == '__main__':
    main()
