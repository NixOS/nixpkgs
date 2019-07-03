#!/usr/bin/env nix-shell
#!nix-shell -p python37Packages.click python37Packages.aiohttp nix -i python3

import asyncio
import pathlib

import click


ROOT = pathlib.Path(__file__).parent
GET_EXTENSIONS = """(with import <localpkgs> {};
let
  hasChecksum = value: lib.isAttrs value && lib.hasAttrByPath ["src" "outputHash"] value;
  getChecksum = name: value:
    if hasChecksum value then {
      submodules = value.src.fetchSubmodules or false;
      sha256 = value.src.outputHash;
      rev = value.src.rev;
    } else null;
  checksums = lib.mapAttrs getChecksum vscode-extensions;
in lib.filterAttrs (n: v: v != null) checksums)"""


class Extension:
    def __init__(self,
                 ):

def coroutine(f):
    '''A generic function to create a main asyncio loop
    '''
    coroutine_f = asyncio.coroutine(f)

    @functools.wraps(coroutine_f)
    def wrapper(*args, **kwargs):
        loop = asyncio.get_event_loop()
        return loop.run_until_complete(coroutine_f(*args, **kwargs))

    return wrapper


class CleanEnvironment(object):
    def __enter__(self) -> None:
        self.old_environ = os.environ.copy()
        local_pkgs = str(ROOT.joinpath("../../.."))
        os.environ["NIX_PATH"] = f"localpkgs={local_pkgs}"
        self.empty_config = NamedTemporaryFile()
        self.empty_config.write(b"{}")
        self.empty_config.flush()
        os.environ["NIXPKGS_CONFIG"] = self.empty_config.name

    def __exit__(self, exc_type: Any, exc_value: Any, traceback: Any) -> None:
        os.environ.update(self.old_environ)
        self.empty_config.close()


def get_current_extensions(): -> List[Extension]:
    with CleanEnvironment():
        out = subprocess.check_output(["nix", "eval", "--json", GET_EXTENSIONS])
    data = json.loads(out)
    extensions = []
    for name, attr in data.items():
        extension = Plugin(name, attr["rev"], attr["submodules"], attr["sha256"])
        extensions.append(extension)
    return extensions


@click.command()
@coroutine
def cmd():
    extensions = get_current_extensions()
    click.echo(extensions)



if __name__ == "__main__":
    cmd()

