import sys
import json
import codecs


def parse_akku_list():
    VERSION_START = 24
    DESCRIPTION_START = 36

    while "====" not in sys.stdin.readline():
        pass

    existing = set()
    name = ""
    all_packages = []
    for ln in sys.stdin.readlines():
        ln = ln.expandtabs()

        # certain package names are too long and are split into two lines
        if not ln[VERSION_START].isdigit():
            name = ln
            continue
        if not name:
            name = ln[:VERSION_START]

        # don't care about versions as they are printed using akku show
        if name not in existing:
            all_packages.append(
                (
                    name.strip(),
                    ln[DESCRIPTION_START:].strip(),
                ),
            )
            existing |= {name}
        name = ""

    json.dump(all_packages, sys.stdout, indent=2)


def parse_akku_show():
    def normalize(s):
        return s.strip().replace(" ", "-").replace("(", "").replace(")", "")

    modname = normalize(sys.argv[2])
    synopsis = sys.argv[3]

    pkg_text = "".join(sys.stdin.readlines())

    intermediate = (
        pkg_text.replace("\x1b", "")
        .replace("[0m", "")
        .replace("[4m", "")
        .encode("ascii", "ignore")
        .decode()
    )
    longname, rest = intermediate.split("\n", maxsplit=1)
    sequence = [
        "Metadata\n",
        "Dependencies\n",
        "Dependencies (development)\n",
        "Source code\n",
        "Available versions\n",
        "\n",
    ]
    real_sequence = list(filter(lambda x: x in rest, sequence))
    i = 1

    longdesc, rest = rest.split("Metadata\n")
    metadata = ""
    dependencies = ""
    dev_dependencies = ""
    source = ""
    available_versions = ""

    def forward(rest, i):
        t, rest = rest.strip().split(real_sequence[i])
        return t, rest, i + 1

    if "Metadata\n" in real_sequence:
        metadata, rest, i = forward(rest, i)

    if "Dependencies\n" in real_sequence:
        dependencies, rest, i = forward(rest, i)

    if "Dependencies (development)\n" in real_sequence:
        dev_dependencies, rest, i = forward(rest, i)

    if "Source code\n" in real_sequence:
        source, rest, i = forward(rest, i)

    if "Available versions\n" in real_sequence:
        available_versions = rest.strip().split("\n")

    assert source, "Source code not found"

    url, sha256 = source.strip().split("\n")
    url = url.split(" ")[-1]
    sha256 = codecs.encode(
        codecs.decode(
            sha256.split(" ")[-1][1:-2],
            "hex",
        ),
        "base64",
    ).decode()[:-1]

    deps = []
    if dependencies:
        for dep in dependencies.strip().split("\n"):
            if dep.startswith("("):
                deps.append(f'"{normalize(dep[1:dep.index(")")])}"')
            else:
                deps.append(f'"{normalize(dep[:dep.index(" ")])}"')

    def prune(s):
        return s.replace('"', "")

    print(f"[{modname}]")
    print(f'dependencies = [{", ".join(deps)}]')
    print(f'synopsis = "{prune(synopsis)}"')
    print(f'longdesc = """{prune(longdesc)}"""')
    print(f'url = "{url}"')
    print(f'sha256 = "{sha256}"')
    print(f'version = "{available_versions[-1]}"')
    print()


if __name__ == "__main__":
    if sys.argv[1] == "akku-list":
        parse_akku_list()
    elif sys.argv[1] == "akku-show":
        parse_akku_show()
    else:
        raise ValueError("Unknown command")
