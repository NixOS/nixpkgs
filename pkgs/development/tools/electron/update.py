#! /usr/bin/env nix-shell
#! nix-shell -i python -p python3.pkgs.joblib python3.pkgs.click python3.pkgs.click-log nix nix-prefetch-git nix-universal-prefetch prefetch-yarn-deps prefetch-npm-deps

import logging
import click_log
import click
import random
import traceback
import csv
import base64
import os
import re
import tempfile
import subprocess
import json
import sys
from joblib import Parallel, delayed, Memory
from codecs import iterdecode
from datetime import datetime
from urllib.request import urlopen

os.chdir(os.path.dirname(__file__))

depot_tools_checkout = tempfile.TemporaryDirectory()
subprocess.check_call([
    "nix-prefetch-git",
    "--builder", "--quiet",
    "--url", "https://chromium.googlesource.com/chromium/tools/depot_tools",
    "--out", depot_tools_checkout.name,
    "--rev", "7a69b031d58081d51c9e8e89557b343bba8518b1"])
sys.path.append(depot_tools_checkout.name)

import gclient_eval
import gclient_utils

memory = Memory("cache", verbose=0)

@memory.cache
def get_repo_hash(fetcher, args):
    cmd = ['nix-universal-prefetch', fetcher]
    for arg_name, arg in args.items():
        cmd.append(f'--{arg_name}')
        cmd.append(arg)

    print(" ".join(cmd), file=sys.stderr)
    out = subprocess.check_output(cmd)
    return out.decode('utf-8').strip()

@memory.cache
def _get_yarn_hash(file):
    print(f'prefetch-yarn-deps', file=sys.stderr)
    with tempfile.TemporaryDirectory() as tmp_dir:
        with open(tmp_dir + '/yarn.lock', 'w') as f:
            f.write(file)
        return subprocess.check_output(['prefetch-yarn-deps', tmp_dir + '/yarn.lock']).decode('utf-8').strip()
def get_yarn_hash(repo, yarn_lock_path = 'yarn.lock'):
    return _get_yarn_hash(repo.get_file(yarn_lock_path))

@memory.cache
def _get_npm_hash(file):
    print(f'prefetch-npm-deps', file=sys.stderr)
    with tempfile.TemporaryDirectory() as tmp_dir:
        with open(tmp_dir + '/package-lock.json', 'w') as f:
            f.write(file)
        return subprocess.check_output(['prefetch-npm-deps', tmp_dir + '/package-lock.json']).decode('utf-8').strip()
def get_npm_hash(repo, package_lock_path = 'package-lock.json'):
    return _get_npm_hash(repo.get_file(package_lock_path))

class Repo:
    def __init__(self):
        self.deps = {}
        self.hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="

    def get_deps(self, repo_vars, path):
        print("evaluating " + json.dumps(self, default = vars), file=sys.stderr)

        deps_file = self.get_file("DEPS")
        evaluated = gclient_eval.Parse(deps_file, filename='DEPS')

        repo_vars = dict(evaluated["vars"]) | repo_vars

        prefix = f"{path}/" if evaluated.get("use_relative_paths", False) else ""

        self.deps = {
            prefix + dep_name: repo_from_dep(dep)
            for dep_name, dep in evaluated["deps"].items()
            if (gclient_eval.EvaluateCondition(dep["condition"], repo_vars) if "condition" in dep else True) and repo_from_dep(dep) != None
        }

        for key in evaluated.get("recursedeps", []):
            dep_path = prefix + key
            if dep_path in self.deps and dep_path != "src/third_party/squirrel.mac":
                self.deps[dep_path].get_deps(repo_vars, dep_path)

    def prefetch(self):
        self.hash = get_repo_hash(self.fetcher, self.args)

    def prefetch_all(self):
        return sum([dep.prefetch_all() for [_, dep] in self.deps.items()], [delayed(self.prefetch)()])

    def flatten_repr(self):
        return {
            "fetcher": self.fetcher,
            "hash": self.hash,
            **self.args
        }

    def flatten(self, path):
        out = {
            path: self.flatten_repr()
        }
        for dep_path, dep in self.deps.items():
            out |= dep.flatten(dep_path)
        return out

class GitRepo(Repo):
    def __init__(self, url, rev):
        super().__init__()
        self.fetcher = 'fetchgit'
        self.args = {
            "url": url,
            "rev": rev,
        }

class GitHubRepo(Repo):
    def __init__(self, owner, repo, rev):
        super().__init__()
        self.fetcher = 'fetchFromGitHub'
        self.args = {
            "owner": owner,
            "repo": repo,
            "rev": rev,
        }

    def get_file(self, filepath):
        return urlopen(f"https://raw.githubusercontent.com/{self.args['owner']}/{self.args['repo']}/{self.args['rev']}/{filepath}").read().decode('utf-8')

class GitilesRepo(Repo):
    def __init__(self, url, rev):
        super().__init__()
        self.fetcher = 'fetchFromGitiles'
        #self.fetcher = 'fetchgit'
        self.args = {
            "url": url,
            "rev": rev,
            #"fetchSubmodules": "false",
        }

        if url == "https://chromium.googlesource.com/chromium/src.git":
            self.args['postFetch'] = "rm -r $out/third_party/blink/web_tests; "
            self.args['postFetch'] += "rm -r $out/third_party/hunspell/tests; "
            self.args['postFetch'] += "rm -r $out/content/test/data; "
            self.args['postFetch'] += "rm -r $out/courgette/testdata; "
            self.args['postFetch'] += "rm -r $out/extensions/test/data; "
            self.args['postFetch'] += "rm -r $out/media/test/data; "

    def get_file(self, filepath):
        return base64.b64decode(urlopen(f"{self.args['url']}/+/{self.args['rev']}/{filepath}?format=TEXT").read()).decode('utf-8')

def repo_from_dep(dep):
    if "url" in dep:
        url, rev = gclient_utils.SplitUrlRevision(dep["url"])

        search_object = re.search(r'https://github.com/(.+)/(.+?)(\.git)?$', url)
        if search_object:
            return GitHubRepo(search_object.group(1), search_object.group(2), rev)

        if re.match(r'https://.+.googlesource.com', url):
            return GitilesRepo(url, rev)

        return GitRepo(url, rev)
    else:
        # Not a git dependency; skip
        return None

def get_gn_source(repo):
    gn_pattern = r"'gn_version': 'git_revision:([0-9a-f]{40})'"
    gn_commit = re.search(gn_pattern, repo.get_file("DEPS")).group(1)
    gn = subprocess.check_output([
        "nix-prefetch-git",
        "--quiet",
        "https://gn.googlesource.com/gn",
        "--rev", gn_commit
        ])
    gn = json.loads(gn)
    return {
        "gn": {
            "version": datetime.fromisoformat(gn["date"]).date().isoformat(),
            "url": gn["url"],
            "rev": gn["rev"],
            "sha256": gn["sha256"]
        }
    }

def get_electron_info(major_version):
    electron_releases = json.loads(urlopen("https://releases.electronjs.org/releases.json").read())
    major_version_releases = filter(lambda item: item["version"].startswith(f"{major_version}."), electron_releases)
    m = max(major_version_releases, key=lambda item: item["date"])

    rev=f"v{m['version']}"

    electron_repo = GitHubRepo("electron", "electron", rev)
    electron_repo.recurse = True

    electron_repo.get_deps({
        f"checkout_{platform}": platform == "linux"
        for platform in ["ios", "chromeos", "android", "mac", "win", "linux"]
    }, "src/electron")

    return (major_version, m, electron_repo)

logger = logging.getLogger(__name__)
click_log.basic_config(logger)

@click.group()
def cli():
    pass

@cli.command("eval")
@click.option("--version", help="The major version, e.g. '23'")
def eval(version):
    (_, _, repo) = electron_repo = get_electron_info(version)
    tree = electron_repo.flatten("src/electron")
    print(json.dumps(tree, indent=4, default = vars))

def get_update(repo):
    (major_version, m, electron_repo) = repo

    tasks = electron_repo.prefetch_all()
    a = lambda: (
        ("electron_yarn_hash", get_yarn_hash(electron_repo))
    )
    tasks.append(delayed(a)())
    a = lambda: (
        ("chromium_npm_hash", get_npm_hash(electron_repo.deps["src"], "third_party/node/package-lock.json"))
    )
    tasks.append(delayed(a)())
    random.shuffle(tasks)

    task_results = {n[0]: n[1] for n in Parallel(n_jobs=3, require='sharedmem', return_as="generator")(tasks) if n != None}

    tree = electron_repo.flatten("src/electron")

    return (f"{major_version}", {
      "deps": tree,
      **{key: m[key] for key in ["version", "modules", "chrome", "node"]},
      "chromium": {
          "version": m['chrome'],
          "deps": get_gn_source(electron_repo.deps["src"])
      },
      **task_results
    })

@cli.command("update")
@click.option("--version", help="The major version, e.g. '23'")
def update(version):
    try:
        with open('info.json', 'r') as f:
            old_info = json.loads(f.read())
    except:
        old_info = {}
    repo = get_electron_info(version)
    update = get_update(repo)
    out = old_info | { update[0]: update[1] }
    with open('info.json', 'w') as f:
        f.write(json.dumps(out, indent=4, default = vars))
        f.write('\n')

@cli.command("update-all")
def update_all():
    repos = Parallel(n_jobs=2, require='sharedmem')(delayed(get_electron_info)(major_version) for major_version in range(27, 24, -1))
    out = {n[0]: n[1] for n in Parallel(n_jobs=2, require='sharedmem')(delayed(get_update)(repo) for repo in repos)}

    with open('info.json', 'w') as f:
        f.write(json.dumps(out, indent=4, default = vars))
        f.write('\n')

if __name__ == "__main__":
    cli()
