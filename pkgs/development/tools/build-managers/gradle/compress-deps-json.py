import json
import sys

from typing import Dict, Set

# this compresses MITM URL lists with Gradle-specific optimizations
# specifically, it splits each url into up to 3 parts - they will be
# concatenated like part1/part2.part3 or part1.part2
# part3 is simply always the file extension, but part1 and part2 is
# optimized using special heuristics
# additionally, if part2 ends with /a/b/{a}-{b}, the all occurences of
# /{a}/{b}/ are replaced with #
# finally, anything that ends with = is considered SHA256, anything that
# starts with http is considered a redirect URL, anything else is
# considered text

with open(sys.argv[1], "rt") as f:
    data: dict = json.load(f)

new_data: Dict[str, Dict[str, Dict[str, dict]]] = {}

for url, info in data.items():
    if url == "!version":
        continue
    ext, base = map(lambda x: x[::-1], url[::-1].split(".", 1))
    if base.endswith(".tar"):
        base = base[:-4]
        ext = "tar." + ext
    # special logic for Maven repos
    if ext in ["jar", "pom", "module"]:
        comps = base.split("/")
        if "-" in comps[-1]:
            # convert base/name/ver/name-ver into base#name/ver

            filename = comps[-1]
            name = comps[-3]
            basever = comps[-2]
            ver = basever
            is_snapshot = ver.endswith("-SNAPSHOT")
            if is_snapshot:
                ver = ver.removesuffix("-SNAPSHOT")
            if filename.startswith(f"{name}-{ver}"):
                if is_snapshot:
                    if filename.startswith(f"{name}-{ver}-SNAPSHOT"):
                        ver += "-SNAPSHOT"
                    else:
                        ver += "-".join(
                            filename.removeprefix(f"{name}-{ver}").split("-")[:3]
                        )
                comp_end = comps[-1].removeprefix(f"{name}-{ver}")
            else:
                ver, name, comp_end = None, None, None
            if name and ver and (not comp_end or comp_end.startswith("-")):
                base = "/".join(comps[:-1]) + "/"
                base = base.replace(f"/{name}/{basever}/", "#")
                base += f"{name}/{ver}"
                if is_snapshot:
                    base += "/SNAPSHOT"
                if comp_end:
                    base += "/" + comp_end[1:]
    scheme, rest = base.split("/", 1)
    if scheme not in new_data.keys():
        new_data[scheme] = {}
    if rest not in new_data[scheme].keys():
        new_data[scheme][rest] = {}
    if "hash" in info.keys():
        new_data[scheme][rest][ext] = info["hash"]
    elif "text" in info.keys() and ext == "xml":
        # nix code in fetch-deps.nix will autogenerate metadata xml files groupId
        # is part of the URL, but it can be tricky to parse as we don't know the
        # exact repo base, so take it from the xml and pass it to nix
        xml = "".join(info["text"].split())
        new_data[scheme][rest][ext] = {
            "groupId": xml.split("<groupId>")[1].split("</groupId>")[0],
        }
        if "<release>" in xml:
            new_data[scheme][rest][ext]["release"] = xml.split("<release>")[1].split(
                "</release>"
            )[0]
        if "<latest>" in xml:
            latest = xml.split("<latest>")[1].split("</latest>")[0]
            if latest != new_data[scheme][rest][ext].get("release"):
                new_data[scheme][rest][ext]["latest"] = latest
        if "<lastUpdated>" in xml:
            new_data[scheme][rest][ext]["lastUpdated"] = xml.split("<lastUpdated>")[
                1
            ].split("</lastUpdated>")[0]
    else:
        raise Exception("Unsupported key: " + repr(info))

# At this point, we have a map by part1 (initially the scheme), part2 (initially a
# slash-separated string without the scheme and with potential # substitution as
# seen above), extension.
# Now, push some segments from "part2" into "part1" like this:
#  https # part1
#   domain1/b # part2
#   domain1/c
#   domain2/a
#   domain2/c
# ->
#  https/domain1 # part1
#   b # part2
#   c
#  https/domain2 # part1
#   a # part2
#   c
# This helps reduce the lockfile size because a Gradle project will usually use lots
# of files from a single Maven repo

data = new_data
changed = True
while changed:
    changed = False
    new_data = {}
    for part1, info1 in data.items():
        starts: Set[str] = set()
        # by how many bytes the file size will be increased (roughly)
        lose = 0
        # by how many bytes the file size will be reduced (roughly)
        win = 0
        # how many different initial part2 segments there are
        count = 0
        for part2, info2 in info1.items():
            if "/" not in part2:
                # can't push a segment from part2 into part1
                count = 0
                break
            st = part2.split("/", 1)[0]
            if st not in starts:
                lose += len(st) + 1
                count += 1
                starts.add(st)
            win += len(st) + 1
        if count == 0:
            new_data[part1] = info1
            continue
        # only allow pushing part2 segments into path1 if *either*:
        # - the domain isn't yet part of part1
        # - the initial part2 segment is always the same
        if count != 1 and "." in part1:
            new_data[part1] = info1
            continue
        # some heuristics that may or may not work well (originally this was
        # used when the above if wasn't here, but perhaps it's useless now)
        lose += (count - 1) * max(0, len(part1) - 4)
        if win > lose or ("." not in part1 and win >= lose):
            changed = True
            for part2, info2 in info1.items():
                st, part3 = part2.split("/", 1)
                new_part1 = part1 + "/" + st
                if new_part1 not in new_data.keys():
                    new_data[new_part1] = {}
                new_data[new_part1][part3] = info2
        else:
            new_data[part1] = info1
    data = new_data

new_data["!comment"] = "This is a nixpkgs Gradle dependency lockfile. For more details, refer to the Gradle section in the nixpkgs manual."  # type: ignore
new_data["!version"] = 1  # type: ignore

with open(sys.argv[2], "wt") as f:
    json.dump(new_data, f, sort_keys=True, indent=1)
    f.write("\n")
