from argparse import ArgumentParser
from dataclasses import dataclass
from functools import cached_property
import json
from pathlib import Path

from libfdt import Fdt, FdtException, FDT_ERR_NOSPACE, fdt_overlay_apply


@dataclass
class Overlay:
    name: str
    filter: str
    dtbo_file: Path

    @cached_property
    def fdt(self):
        with self.dtbo_file.open("rb") as fd:
            return Fdt(fd.read())

    @cached_property
    def compatible(self):
        return get_compatible(self.fdt)


def get_compatible(fdt):
    root_offset = fdt.path_offset("/")
    return set(fdt.getprop(root_offset, "compatible").as_stringlist())


def apply_overlay(dt: Fdt, dto: Fdt) -> Fdt:
    while True:
        # we need to copy the buffers because they can be left in an inconsistent state
        # if the operation fails (ref: fdtoverlay source)
        result = dt.as_bytearray().copy()
        err = fdt_overlay_apply(result, dto.as_bytearray().copy())

        if err == 0:
            new_dt = Fdt(result)
            # trim the extra space from the final tree
            new_dt.pack()
            return new_dt

        if err == -FDT_ERR_NOSPACE:
            # not enough space, add some blank space and try again
            # magic number of more space taken from fdtoverlay
            dt.resize(dt.totalsize() + 65536)
            continue

        raise FdtException(err)

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

    for source_dt in source.glob("**/*.dtb"):
        rel_path = source_dt.relative_to(source)

        print(f"Processing source device tree {rel_path}...")
        with source_dt.open("rb") as fd:
            dt = Fdt(fd.read())

        dt_compatible = get_compatible(dt)

        for overlay in overlays_data:
            if overlay.filter and overlay.filter not in str(rel_path):
                print(f"  Skipping overlay {overlay.name}: filter does not match")
                continue

            if not overlay.compatible.intersection(dt_compatible):
                print(f"  Skipping overlay {overlay.name}: {overlay.compatible} is incompatible with {dt_compatible}")
                continue

            print(f"  Applying overlay {overlay.name}")
            dt = apply_overlay(dt, overlay.fdt)

        print(f"Saving final device tree {rel_path}...")
        dest_path = destination / rel_path
        dest_path.parent.mkdir(parents=True, exist_ok=True)
        with dest_path.open("wb") as fd:
            fd.write(dt.as_bytearray())


if __name__ == '__main__':
    main()
