#! /usr/bin/env nix-shell
#! nix-shell -i python -p python3 nix nix-prefetch-git nix-universal-prefetch prefetch-yarn-deps prefetch-npm-deps

import traceback
import csv
import base64
import os
import re
import tempfile
import subprocess
import json
import sys
from codecs import iterdecode
from datetime import datetime
from urllib.request import urlopen

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

cache = {}

def cache_key(dep):
    return json.dumps({ attr: dep[attr] for attr in dep if attr != "hash" })

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
        key = cache_key(self.flatten_repr())
        if not key in cache:
            cmd = ['nix-universal-prefetch', self.fetcher]
            for arg_name, arg in self.args.items():
                cmd.append(f'--{arg_name}')
                cmd.append(arg)

            print(" ".join(cmd), file=sys.stderr)
            out = subprocess.check_output(cmd)
            cache[key] = out.decode('utf-8').strip()
        self.hash = cache[key]

    def prefetch_all(self):
        self.prefetch()
        for [_, dep] in self.deps.items():
            dep.prefetch_all()

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
        self.args = {
            "url": url,
            "rev": rev,
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

def get_yarn_hash(repo, yarn_lock_path = 'yarn.lock'):
    key = "yarn-"+cache_key(repo.flatten_repr())
    if not key in cache:
        print(f'prefetch-yarn-deps', file=sys.stderr)
        with tempfile.TemporaryDirectory() as tmp_dir:
            with open(tmp_dir + '/yarn.lock', 'w') as f:
                f.write(repo.get_file(yarn_lock_path))
            cache[key] = subprocess.check_output(['prefetch-yarn-deps', tmp_dir + '/yarn.lock']).decode('utf-8').strip()
    return cache[key]

def get_npm_hash(repo, package_lock_path = 'package-lock.json'):
    key = "npm-"+cache_key(repo.flatten_repr())
    if not key in cache:
        print(f'prefetch-npm-deps', file=sys.stderr)
        with tempfile.TemporaryDirectory() as tmp_dir:
            with open(tmp_dir + '/package-lock.json', 'w') as f:
                f.write(repo.get_file(package_lock_path))
            cache[key] = subprocess.check_output(['prefetch-npm-deps', tmp_dir + '/package-lock.json']).decode('utf-8').strip()
    return cache[key]

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

try:
    with open('info.json', 'r') as f:
        old_info = json.loads(f.read())
        for [_, version] in old_info.items():
            for [dep_path, dep] in version["deps"].items():
                cache[cache_key(dep)] = dep["hash"]
            cache["npm-"+cache_key(version["deps"]["src"])] = version["chromium_npm_hash"]
            cache["yarn-"+cache_key(version["deps"]["src/electron"])] = version["electron_yarn_hash"]
except:
    print("not using cache: ", file=sys.stderr)
    traceback.print_exc()

out = {}

electron_releases = json.loads(urlopen("https://releases.electronjs.org/releases.json").read())

for major_version in range(27, 21, -1):
    major_version_releases = filter(lambda item: item["version"].startswith(f"{major_version}."), electron_releases)
    m = max(major_version_releases, key=lambda item: item["date"])

    rev=f"v{m['version']}"

    electron_repo = GitHubRepo("electron", "electron", rev)
    electron_repo.recurse = True

    electron_repo.get_deps({
        f"checkout_{platform}": platform == "linux"
        for platform in ["ios", "chromeos", "android", "mac", "win", "linux"]
    }, "src/electron")

    electron_repo.prefetch_all()

    tree = electron_repo.flatten("src/electron")

    out[f"{major_version}"] = {
      "electron_yarn_hash": get_yarn_hash(electron_repo),
      "chromium_npm_hash": get_npm_hash(electron_repo.deps["src"], "third_party/node/package-lock.json"),
      "deps": tree,
      **{key: m[key] for key in ["version", "modules", "chrome"]},
      "chromium": {
          "version": m['chrome'],
          "deps": get_gn_source(electron_repo.deps["src"])
      }
    }

with open('info.json', 'w') as f:
    f.write(json.dumps(out, indent=4, default = vars))
    f.write('\n')
