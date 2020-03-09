#!/usr/bin/env nix-shell
#!nix-shell -p nix-prefetch-git -p python3 nix -i python3

# format:
# $ nix run nixpkgs.python3Packages.black -c black update.py
# type-check:
# $ nix run nixpkgs.python3Packages.mypy -c mypy update.py
# linted:
# $ nix run nixpkgs.python3Packages.flake8 -c flake8 --ignore E501,E265 update.py

import argparse
import functools
import json
import os
import subprocess
import sys
import traceback
import urllib.error
import urllib.request
import xml.etree.ElementTree as ET
from datetime import datetime
from multiprocessing.dummy import Pool
from pathlib import Path
from typing import Dict, List, Optional, Tuple, Union, Any, Callable
from urllib.parse import urljoin, urlparse
from tempfile import NamedTemporaryFile

ATOM_ENTRY = "{http://www.w3.org/2005/Atom}entry"  # " vim gets confused here
ATOM_LINK = "{http://www.w3.org/2005/Atom}link"  # "
ATOM_UPDATED = "{http://www.w3.org/2005/Atom}updated"  # "

ROOT = Path(__file__).parent
DEFAULT_IN = ROOT.joinpath("vim-plugin-names")
DEFAULT_OUT = ROOT.joinpath("generated.nix")

import time
from functools import wraps


def retry(ExceptionToCheck: Any, tries: int = 4, delay: float = 3, backoff: float = 2):
    """Retry calling the decorated function using an exponential backoff.

    http://www.saltycrane.com/blog/2009/11/trying-out-retry-decorator-python/
    original from: http://wiki.python.org/moin/PythonDecoratorLibrary#Retry
    (BSD licensed)

    :param ExceptionToCheck: the exception on which to retry
    :param tries: number of times to try (not retry) before giving up
    :param delay: initial delay between retries in seconds
    :param backoff: backoff multiplier e.g. value of 2 will double the delay
        each retry
    """

    def deco_retry(f: Callable) -> Callable:
        @wraps(f)
        def f_retry(*args: Any, **kwargs: Any) -> Any:
            mtries, mdelay = tries, delay
            while mtries > 1:
                try:
                    return f(*args, **kwargs)
                except ExceptionToCheck as e:
                    print(f"{str(e)}, Retrying in {mdelay} seconds...")
                    time.sleep(mdelay)
                    mtries -= 1
                    mdelay *= backoff
            return f(*args, **kwargs)

        return f_retry  # true decorator

    return deco_retry


class Repo:
    def __init__(self, owner: str, name: str) -> None:
        self.owner = owner
        self.name = name

    def url(self, path: str) -> str:
        return urljoin(f"https://github.com/{self.owner}/{self.name}/", path)

    def __repr__(self) -> str:
        return f"Repo({self.owner}, {self.name})"

    @retry(urllib.error.URLError, tries=4, delay=3, backoff=2)
    def has_submodules(self) -> bool:
        try:
            urllib.request.urlopen(
                self.url("blob/master/.gitmodules"), timeout=10
            ).close()
        except urllib.error.HTTPError as e:
            if e.code == 404:
                return False
            else:
                raise
        return True

    @retry(urllib.error.URLError, tries=4, delay=3, backoff=2)
    def latest_commit(self) -> Tuple[str, datetime]:
        with urllib.request.urlopen(self.url("commits/master.atom"), timeout=10) as req:
            xml = req.read()
            root = ET.fromstring(xml)
            latest_entry = root.find(ATOM_ENTRY)
            assert latest_entry is not None, f"No commits found in repository {self}"
            commit_link = latest_entry.find(ATOM_LINK)
            assert commit_link is not None, f"No link tag found feed entry {xml}"
            url = urlparse(commit_link.get("href"))
            updated_tag = latest_entry.find(ATOM_UPDATED)
            assert (
                updated_tag is not None and updated_tag.text is not None
            ), f"No updated tag found feed entry {xml}"
            updated = datetime.strptime(updated_tag.text, "%Y-%m-%dT%H:%M:%SZ")
            return Path(str(url.path)).name, updated

    def prefetch_git(self, ref: str) -> str:
        data = subprocess.check_output(
            ["nix-prefetch-git", "--fetch-submodules", self.url(""), ref]
        )
        return json.loads(data)["sha256"]

    def prefetch_github(self, ref: str) -> str:
        data = subprocess.check_output(
            ["nix-prefetch-url", "--unpack", self.url(f"archive/{ref}.tar.gz")]
        )
        return data.strip().decode("utf-8")


class Plugin:
    def __init__(
        self,
        name: str,
        commit: str,
        has_submodules: bool,
        sha256: str,
        date: Optional[datetime] = None,
    ) -> None:
        self.name = name
        self.commit = commit
        self.has_submodules = has_submodules
        self.sha256 = sha256
        self.date = date

    @property
    def normalized_name(self) -> str:
        return self.name.replace(".", "-")

    @property
    def version(self) -> str:
        assert self.date is not None
        return self.date.strftime("%Y-%m-%d")

    def as_json(self) -> Dict[str, str]:
        copy = self.__dict__.copy()
        del copy["date"]
        return copy


GET_PLUGINS = f"""(with import <localpkgs> {{}};
let
  inherit (vimUtils.override {{inherit vim;}}) buildVimPluginFrom2Nix;
  generated = callPackage {ROOT}/generated.nix {{
    inherit buildVimPluginFrom2Nix;
  }};
  hasChecksum = value: lib.isAttrs value && lib.hasAttrByPath ["src" "outputHash"] value;
  getChecksum = name: value:
    if hasChecksum value then {{
      submodules = value.src.fetchSubmodules or false;
      sha256 = value.src.outputHash;
      rev = value.src.rev;
    }} else null;
  checksums = lib.mapAttrs getChecksum generated;
in lib.filterAttrs (n: v: v != null) checksums)"""


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


def get_current_plugins() -> List[Plugin]:
    with CleanEnvironment():
        out = subprocess.check_output(["nix", "eval", "--json", GET_PLUGINS])
    data = json.loads(out)
    plugins = []
    for name, attr in data.items():
        p = Plugin(name, attr["rev"], attr["submodules"], attr["sha256"])
        plugins.append(p)
    return plugins


def prefetch_plugin(user: str, repo_name: str, alias: str, cache: "Cache") -> Plugin:
    repo = Repo(user, repo_name)
    commit, date = repo.latest_commit()
    has_submodules = repo.has_submodules()
    cached_plugin = cache[commit]
    if cached_plugin is not None:
        cached_plugin.name = alias or repo_name
        cached_plugin.date = date
        return cached_plugin

    print(f"prefetch {user}/{repo_name}")
    if has_submodules:
        sha256 = repo.prefetch_git(commit)
    else:
        sha256 = repo.prefetch_github(commit)

    return Plugin(alias or repo_name, commit, has_submodules, sha256, date=date)


def print_download_error(plugin: str, ex: Exception):
    print(f"{plugin}: {ex}", file=sys.stderr)
    ex_traceback = ex.__traceback__
    tb_lines = [
        line.rstrip("\n")
        for line in traceback.format_exception(ex.__class__, ex, ex_traceback)
    ]
    print("\n".join(tb_lines))


def check_results(
    results: List[Tuple[str, str, Union[Exception, Plugin]]]
) -> List[Tuple[str, str, Plugin]]:
    failures: List[Tuple[str, Exception]] = []
    plugins = []
    for (owner, name, result) in results:
        if isinstance(result, Exception):
            failures.append((name, result))
        else:
            plugins.append((owner, name, result))

    print(f"{len(results) - len(failures)} plugins were checked", end="")
    if len(failures) == 0:
        print()
        return plugins
    else:
        print(f", {len(failures)} plugin(s) could not be downloaded:\n")

        for (plugin, exception) in failures:
            print_download_error(plugin, exception)

        sys.exit(1)


def parse_plugin_line(line: str) -> Tuple[str, str, Optional[str]]:
    name, repo = line.split("/")
    try:
        repo, alias = repo.split(" as ")
        return (name, repo, alias.strip())
    except ValueError:
        # no alias defined
        return (name, repo.strip(), None)


def load_plugin_spec(plugin_file: str) -> List[Tuple[str, str, Optional[str]]]:
    plugins = []
    with open(plugin_file) as f:
        for line in f:
            plugin = parse_plugin_line(line)
            if not plugin[0]:
                msg = f"Invalid repository {line}, must be in the format owner/repo[ as alias]"
                print(msg, file=sys.stderr)
                sys.exit(1)
            plugins.append(plugin)
    return plugins


def get_cache_path() -> Optional[Path]:
    xdg_cache = os.environ.get("XDG_CACHE_HOME", None)
    if xdg_cache is None:
        home = os.environ.get("HOME", None)
        if home is None:
            return None
        xdg_cache = str(Path(home, ".cache"))

    return Path(xdg_cache, "vim-plugin-cache.json")


class Cache:
    def __init__(self, initial_plugins: List[Plugin]) -> None:
        self.cache_file = get_cache_path()

        downloads = {}
        for plugin in initial_plugins:
            downloads[plugin.commit] = plugin
        downloads.update(self.load())
        self.downloads = downloads

    def load(self) -> Dict[str, Plugin]:
        if self.cache_file is None or not self.cache_file.exists():
            return {}

        downloads: Dict[str, Plugin] = {}
        with open(self.cache_file) as f:
            data = json.load(f)
            for attr in data.values():
                p = Plugin(
                    attr["name"], attr["commit"], attr["has_submodules"], attr["sha256"]
                )
                downloads[attr["commit"]] = p
        return downloads

    def store(self) -> None:
        if self.cache_file is None:
            return

        os.makedirs(self.cache_file.parent, exist_ok=True)
        with open(self.cache_file, "w+") as f:
            data = {}
            for name, attr in self.downloads.items():
                data[name] = attr.as_json()
            json.dump(data, f, indent=4, sort_keys=True)

    def __getitem__(self, key: str) -> Optional[Plugin]:
        return self.downloads.get(key, None)

    def __setitem__(self, key: str, value: Plugin) -> None:
        self.downloads[key] = value


def prefetch(
    args: Tuple[str, str, str], cache: Cache
) -> Tuple[str, str, Union[Exception, Plugin]]:
    assert len(args) == 3
    owner, repo, alias = args
    try:
        plugin = prefetch_plugin(owner, repo, alias, cache)
        cache[plugin.commit] = plugin
        return (owner, repo, plugin)
    except Exception as e:
        return (owner, repo, e)


header = (
    "# This file has been generated by ./pkgs/misc/vim-plugins/update.py. Do not edit!"
)


def generate_nix(plugins: List[Tuple[str, str, Plugin]], outfile: str):
    sorted_plugins = sorted(plugins, key=lambda v: v[2].name.lower())

    with open(outfile, "w+") as f:
        f.write(header)
        f.write(
            """
{ lib, buildVimPluginFrom2Nix, fetchFromGitHub, overrides ? (self: super: {}) }:

let
  packages = ( self:
{"""
        )
        for owner, repo, plugin in sorted_plugins:
            if plugin.has_submodules:
                submodule_attr = "\n      fetchSubmodules = true;"
            else:
                submodule_attr = ""

            f.write(
                f"""
  {plugin.normalized_name} = buildVimPluginFrom2Nix {{
    pname = "{plugin.normalized_name}";
    version = "{plugin.version}";
    src = fetchFromGitHub {{
      owner = "{owner}";
      repo = "{repo}";
      rev = "{plugin.commit}";
      sha256 = "{plugin.sha256}";{submodule_attr}
    }};
  }};
"""
            )
        f.write(
            """
});
in lib.fix' (lib.extends overrides packages)
"""
        )
    print(f"updated {outfile}")


def parse_args():
    parser = argparse.ArgumentParser(
        description=(
            "Updates nix derivations for vim plugins"
            f"By default from {DEFAULT_IN} to {DEFAULT_OUT}"
        )
    )
    parser.add_argument(
        "--input-names",
        "-i",
        dest="input_file",
        default=DEFAULT_IN,
        help="A list of plugins in the form owner/repo",
    )
    parser.add_argument(
        "--out",
        "-o",
        dest="outfile",
        default=DEFAULT_OUT,
        help="Filename to save generated nix code",
    )

    return parser.parse_args()


def main() -> None:

    args = parse_args()
    plugin_names = load_plugin_spec(args.input_file)
    current_plugins = get_current_plugins()
    cache = Cache(current_plugins)

    prefetch_with_cache = functools.partial(prefetch, cache=cache)

    try:
        # synchronous variant for debugging
        # results = list(map(prefetch_with_cache, plugin_names))
        pool = Pool(processes=30)
        results = pool.map(prefetch_with_cache, plugin_names)
    finally:
        cache.store()

    plugins = check_results(results)

    generate_nix(plugins, args.outfile)


if __name__ == "__main__":
    main()
