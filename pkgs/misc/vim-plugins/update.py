#!/usr/bin/env nix-shell
#!nix-shell -p nix-prefetch-git -p python3 -p python3Packages.GitPython nix -i python3

# format:
# $ nix run nixpkgs.python3Packages.black -c black update.py
# type-check:
# $ nix run nixpkgs.python3Packages.mypy -c mypy update.py
# linted:
# $ nix run nixpkgs.python3Packages.flake8 -c flake8 --ignore E501,E265 update.py

import argparse
import functools
import http
import json
import os
import subprocess
import sys
import time
import traceback
import urllib.error
import urllib.parse
import urllib.request
import xml.etree.ElementTree as ET
from datetime import datetime
from functools import wraps
from multiprocessing.dummy import Pool
from pathlib import Path
from typing import Dict, List, Optional, Tuple, Union, Any, Callable
from urllib.parse import urljoin, urlparse
from tempfile import NamedTemporaryFile

import git

ATOM_ENTRY = "{http://www.w3.org/2005/Atom}entry"  # " vim gets confused here
ATOM_LINK = "{http://www.w3.org/2005/Atom}link"  # "
ATOM_UPDATED = "{http://www.w3.org/2005/Atom}updated"  # "

ROOT = Path(__file__).parent
DEFAULT_IN = ROOT.joinpath("vim-plugin-names")
DEFAULT_OUT = ROOT.joinpath("generated.nix")
DEPRECATED = ROOT.joinpath("deprecated.json")

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

def make_request(url: str) -> urllib.request.Request:
    token = os.getenv("GITHUB_API_TOKEN")
    headers = {}
    if token is not None:
       headers["Authorization"] = f"token {token}"
    return urllib.request.Request(url, headers=headers)

class Repo:
    def __init__(
        self, owner: str, name: str, branch: str, alias: Optional[str]
    ) -> None:
        self.owner = owner
        self.name = name
        self.branch = branch
        self.alias = alias
        self.redirect: Dict[str, str] = {}

    def url(self, path: str) -> str:
        return urljoin(f"https://github.com/{self.owner}/{self.name}/", path)

    def __repr__(self) -> str:
        return f"Repo({self.owner}, {self.name})"

    @retry(urllib.error.URLError, tries=4, delay=3, backoff=2)
    def has_submodules(self) -> bool:
        try:
            req = make_request(self.url(f"blob/{self.branch}/.gitmodules"))
            urllib.request.urlopen(req, timeout=10).close()
        except urllib.error.HTTPError as e:
            if e.code == 404:
                return False
            else:
                raise
        return True

    @retry(urllib.error.URLError, tries=4, delay=3, backoff=2)
    def latest_commit(self) -> Tuple[str, datetime]:
        commit_url = self.url(f"commits/{self.branch}.atom")
        commit_req = make_request(commit_url)
        with urllib.request.urlopen(commit_req, timeout=10) as req:
            self.check_for_redirect(commit_url, req)
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

    def check_for_redirect(self, url: str, req: http.client.HTTPResponse):
        response_url = req.geturl()
        if url != response_url:
            new_owner, new_name = (
                urllib.parse.urlsplit(response_url).path.strip("/").split("/")[:2]
            )
            end_line = "\n" if self.alias is None else f" as {self.alias}\n"
            plugin_line = "{owner}/{name}" + end_line

            old_plugin = plugin_line.format(owner=self.owner, name=self.name)
            new_plugin = plugin_line.format(owner=new_owner, name=new_name)
            self.redirect[old_plugin] = new_plugin

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


def prefetch_plugin(
    user: str,
    repo_name: str,
    branch: str,
    alias: Optional[str],
    cache: "Optional[Cache]" = None,
) -> Tuple[Plugin, Dict[str, str]]:
    repo = Repo(user, repo_name, branch, alias)
    commit, date = repo.latest_commit()
    has_submodules = repo.has_submodules()
    cached_plugin = cache[commit] if cache else None
    if cached_plugin is not None:
        cached_plugin.name = alias or repo_name
        cached_plugin.date = date
        return cached_plugin, repo.redirect

    print(f"prefetch {user}/{repo_name}")
    if has_submodules:
        sha256 = repo.prefetch_git(commit)
    else:
        sha256 = repo.prefetch_github(commit)

    return (
        Plugin(alias or repo_name, commit, has_submodules, sha256, date=date),
        repo.redirect,
    )


def fetch_plugin_from_pluginline(plugin_line: str) -> Plugin:
    plugin, _ = prefetch_plugin(*parse_plugin_line(plugin_line))
    return plugin


def print_download_error(plugin: str, ex: Exception):
    print(f"{plugin}: {ex}", file=sys.stderr)
    ex_traceback = ex.__traceback__
    tb_lines = [
        line.rstrip("\n")
        for line in traceback.format_exception(ex.__class__, ex, ex_traceback)
    ]
    print("\n".join(tb_lines))


def check_results(
    results: List[Tuple[str, str, Union[Exception, Plugin], Dict[str, str]]]
) -> Tuple[List[Tuple[str, str, Plugin]], Dict[str, str]]:
    failures: List[Tuple[str, Exception]] = []
    plugins = []
    redirects: Dict[str, str] = {}
    for (owner, name, result, redirect) in results:
        if isinstance(result, Exception):
            failures.append((name, result))
        else:
            plugins.append((owner, name, result))
            redirects.update(redirect)

    print(f"{len(results) - len(failures)} plugins were checked", end="")
    if len(failures) == 0:
        print()
        return plugins, redirects
    else:
        print(f", {len(failures)} plugin(s) could not be downloaded:\n")

        for (plugin, exception) in failures:
            print_download_error(plugin, exception)

        sys.exit(1)


def parse_plugin_line(line: str) -> Tuple[str, str, str, Optional[str]]:
    branch = "master"
    alias = None
    name, repo = line.split("/")
    if " as " in repo:
        repo, alias = repo.split(" as ")
        alias = alias.strip()
    if "@" in repo:
        repo, branch = repo.split("@")

    return (name.strip(), repo.strip(), branch.strip(), alias)


def load_plugin_spec(plugin_file: str) -> List[Tuple[str, str, str, Optional[str]]]:
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
    args: Tuple[str, str, str, Optional[str]], cache: Cache
) -> Tuple[str, str, Union[Exception, Plugin], dict]:
    assert len(args) == 4
    owner, repo, branch, alias = args
    try:
        plugin, redirect = prefetch_plugin(owner, repo, branch, alias, cache)
        cache[plugin.commit] = plugin
        return (owner, repo, plugin, redirect)
    except Exception as e:
        return (owner, repo, e, {})


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
    meta.homepage = "https://github.com/{owner}/{repo}/";
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


def rewrite_input(
    input_file: Path, redirects: Dict[str, str] = None, append: Tuple = ()
):
    with open(input_file, "r") as f:
        lines = f.readlines()

    lines.extend(append)

    if redirects:
        lines = [redirects.get(line, line) for line in lines]

        cur_date_iso = datetime.now().strftime("%Y-%m-%d")
        with open(DEPRECATED, "r") as f:
            deprecations = json.load(f)
        for old, new in redirects.items():
            old_plugin = fetch_plugin_from_pluginline(old)
            new_plugin = fetch_plugin_from_pluginline(new)
            if old_plugin.normalized_name != new_plugin.normalized_name:
                deprecations[old_plugin.normalized_name] = {
                    "new": new_plugin.normalized_name,
                    "date": cur_date_iso,
                }
        with open(DEPRECATED, "w") as f:
            json.dump(deprecations, f, indent=4, sort_keys=True)

    lines = sorted(lines, key=str.casefold)

    with open(input_file, "w") as f:
        f.writelines(lines)


def parse_args():
    parser = argparse.ArgumentParser(
        description=(
            "Updates nix derivations for vim plugins"
            f"By default from {DEFAULT_IN} to {DEFAULT_OUT}"
        )
    )
    parser.add_argument(
        "--add",
        dest="add_plugins",
        default=[],
        action="append",
        help="Plugin to add to vimPlugins from Github in the form owner/repo",
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
    parser.add_argument(
        "--proc",
        "-p",
        dest="proc",
        type=int,
        default=30,
        help="Number of concurrent processes to spawn.",
    )
    return parser.parse_args()


def commit(repo: git.Repo, message: str, files: List[Path]) -> None:
    files_staged = repo.index.add([str(f.resolve()) for f in files])

    if files_staged:
        print(f'committing to nixpkgs "{message}"')
        repo.index.commit(message)
    else:
        print("no changes in working tree to commit")


def get_update(input_file: str, outfile: str, proc: int):
    cache: Cache = Cache(get_current_plugins())
    _prefetch = functools.partial(prefetch, cache=cache)

    def update() -> dict:
        plugin_names = load_plugin_spec(input_file)

        try:
            pool = Pool(processes=proc)
            results = pool.map(_prefetch, plugin_names)
        finally:
            cache.store()

        plugins, redirects = check_results(results)

        generate_nix(plugins, outfile)

        return redirects

    return update


def main():
    args = parse_args()
    nixpkgs_repo = git.Repo(ROOT, search_parent_directories=True)
    update = get_update(args.input_file, args.outfile, args.proc)

    redirects = update()
    rewrite_input(args.input_file, redirects)
    commit(nixpkgs_repo, "vimPlugins: update", [args.outfile])

    if redirects:
        update()
        commit(
            nixpkgs_repo,
            "vimPlugins: resolve github repository redirects",
            [args.outfile, args.input_file, DEPRECATED],
        )

    for plugin_line in args.add_plugins:
        rewrite_input(args.input_file, append=(plugin_line + "\n",))
        update()
        plugin = fetch_plugin_from_pluginline(plugin_line)
        commit(
            nixpkgs_repo,
            "vimPlugins.{name}: init at {version}".format(
                name=plugin.normalized_name, version=plugin.version
            ),
            [args.outfile, args.input_file],
        )


if __name__ == "__main__":
    main()
