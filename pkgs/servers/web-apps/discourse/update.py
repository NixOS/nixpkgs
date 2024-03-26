#!/usr/bin/env nix-shell
#! nix-shell -i python3 -p bundix bundler nix-update nix-universal-prefetch "python3.withPackages (ps: with ps; [ requests click click-log packaging ])" prefetch-yarn-deps
from __future__ import annotations

import click
import click_log
import shutil
import tempfile
import re
import logging
import subprocess
import os
import stat
import json
import requests
import textwrap
from functools import total_ordering
from packaging.version import Version
from pathlib import Path
from typing import Union, Iterable


logger = logging.getLogger(__name__)


@total_ordering
class DiscourseVersion:
    """Represents a Discourse style version number and git tag.

    This takes either a tag or version string as input and
    extrapolates the other. Sorting is implemented to work as expected
    in regard to A.B.C.betaD version numbers - 2.0.0.beta1 is
    considered lower than 2.0.0.

    """

    tag: str = ""
    version: str = ""
    split_version: Iterable[Union[None, int, str]] = []

    def __init__(self, version: str):
        """Take either a tag or version number, calculate the other."""
        if version.startswith('v'):
            self.tag = version
            self.version = version.lstrip('v')
        else:
            self.tag = 'v' + version
            self.version = version

        self._version = Version(self.version)

    def __eq__(self, other: DiscourseVersion):
        """Versions are equal when their individual parts are."""
        return self._version == other._version

    def __gt__(self, other: DiscourseVersion):
        """Check if this version is greater than the other."""
        return self._version > other._version


class DiscourseRepo:
    version_regex = re.compile(r'^v\d+\.\d+\.\d+(\.beta\d+)?$')
    _latest_commit_sha = None

    def __init__(self, owner: str = 'discourse', repo: str = 'discourse'):
        self.owner = owner
        self.repo = repo

    @property
    def versions(self) -> Iterable[str]:
        r = requests.get(f'https://api.github.com/repos/{self.owner}/{self.repo}/git/refs/tags').json()
        tags = [x['ref'].replace('refs/tags/', '') for x in r]

        # filter out versions not matching version_regex
        versions = filter(self.version_regex.match, tags)
        versions = [DiscourseVersion(x) for x in versions]
        versions.sort(reverse=True)
        return versions

    @property
    def latest_commit_sha(self) -> str:
        if self._latest_commit_sha is None:
            r = requests.get(f'https://api.github.com/repos/{self.owner}/{self.repo}/commits?per_page=1')
            r.raise_for_status()
            self._latest_commit_sha = r.json()[0]['sha']

        return self._latest_commit_sha

    def get_yarn_lock_hash(self, rev: str):
        yarnLockText = self.get_file('app/assets/javascripts/yarn.lock', rev)
        with tempfile.NamedTemporaryFile(mode='w') as lockFile:
            lockFile.write(yarnLockText)
            return subprocess.check_output(['prefetch-yarn-deps', lockFile.name]).decode('utf-8').strip()

    def get_file(self, filepath, rev):
        """Return file contents at a given rev.

        :param str filepath: the path to the file, relative to the repo root
        :param str rev: the rev to fetch at :return:

        """
        r = requests.get(f'https://raw.githubusercontent.com/{self.owner}/{self.repo}/{rev}/{filepath}')
        r.raise_for_status()
        return r.text


def _call_nix_update(pkg, version):
    """Call nix-update from nixpkgs root dir."""
    nixpkgs_path = Path(__file__).parent / '../../../../'
    return subprocess.check_output(['nix-update', pkg, '--version', version], cwd=nixpkgs_path)


def _nix_eval(expr: str):
    nixpkgs_path = Path(__file__).parent / '../../../../'
    try:
        output = subprocess.check_output(['nix-instantiate', '--strict', '--json', '--eval', '-E', f'(with import {nixpkgs_path} {{}}; {expr})'], text=True)
    except subprocess.CalledProcessError:
        return None
    return json.loads(output)


def _get_current_package_version(pkg: str):
    return _nix_eval(f'{pkg}.version')


def _diff_file(filepath: str, old_version: DiscourseVersion, new_version: DiscourseVersion):
    repo = DiscourseRepo()

    current_dir = Path(__file__).parent

    old = repo.get_file(filepath, old_version.tag)
    new = repo.get_file(filepath, new_version.tag)

    if old == new:
        click.secho(f'{filepath} is unchanged', fg='green')
        return

    with tempfile.NamedTemporaryFile(mode='w') as o, tempfile.NamedTemporaryFile(mode='w') as n:
        o.write(old), n.write(new)
        width = shutil.get_terminal_size((80, 20)).columns
        diff_proc = subprocess.run(
            ['diff', '--color=always', f'--width={width}', '-y', o.name, n.name],
            stdout=subprocess.PIPE,
            cwd=current_dir,
            text=True
        )

    click.secho(f'Diff for {filepath} ({old_version.version} -> {new_version.version}):', fg='bright_blue', bold=True)
    click.echo(diff_proc.stdout + '\n')
    return


def _remove_platforms(rubyenv_dir: Path):
    for platform in ['arm64-darwin-20', 'x86_64-darwin-18',
                     'x86_64-darwin-19', 'x86_64-darwin-20',
                     'x86_64-linux', 'aarch64-linux']:
        with open(rubyenv_dir / 'Gemfile.lock', 'r') as f:
            for line in f:
                if platform in line:
                    subprocess.check_output(
                        ['bundle', 'lock', '--remove-platform', platform], cwd=rubyenv_dir)
                    break


@click_log.simple_verbosity_option(logger)


@click.group()
def cli():
    pass


@cli.command()
@click.argument('rev', default='latest')
@click.option('--reverse/--no-reverse', default=False, help='Print diffs from REV to current.')
def print_diffs(rev, reverse):
    """Print out diffs for files used as templates for the NixOS module.

    The current package version found in the nixpkgs worktree the
    script is run from will be used to download the "from" file and
    REV used to download the "to" file for the diff, unless the
    '--reverse' flag is specified.

    REV should be the git rev to find changes in ('vX.Y.Z') or
    'latest'; defaults to 'latest'.

    """
    if rev == 'latest':
        repo = DiscourseRepo()
        rev = repo.versions[0].tag

    old_version = DiscourseVersion(_get_current_package_version('discourse'))
    new_version = DiscourseVersion(rev)

    if reverse:
        old_version, new_version = new_version, old_version

    for f in ['config/nginx.sample.conf', 'config/discourse_defaults.conf']:
        _diff_file(f, old_version, new_version)


@cli.command()
@click.argument('rev', default='latest')
def update(rev):
    """Update gem files and version.

    REV: the git rev to update to ('vX.Y.Z[.betaA]') or
    'latest'; defaults to 'latest'.

    """
    repo = DiscourseRepo()

    if rev == 'latest':
        version = repo.versions[0]
    else:
        version = DiscourseVersion(rev)

    logger.debug(f"Using rev {version.tag}")
    logger.debug(f"Using version {version.version}")

    rubyenv_dir = Path(__file__).parent / "rubyEnv"

    for fn in ['Gemfile.lock', 'Gemfile']:
        with open(rubyenv_dir / fn, 'w') as f:
            f.write(repo.get_file(fn, version.tag))

    subprocess.check_output(['bundle', 'lock'], cwd=rubyenv_dir)
    _remove_platforms(rubyenv_dir)
    subprocess.check_output(['bundix'], cwd=rubyenv_dir)

    _call_nix_update('discourse', version.version)

    old_yarn_hash = _nix_eval('discourse.assets.yarnOfflineCache.outputHash')
    new_yarn_hash = repo.get_yarn_lock_hash(version.tag)
    click.echo(f"Updating yarn lock hash, {old_yarn_hash} -> {new_yarn_hash}")
    with open(Path(__file__).parent / "default.nix", 'r+') as f:
        content = f.read()
        content = content.replace(old_yarn_hash, new_yarn_hash)
        f.seek(0)
        f.write(content)
        f.truncate()


@cli.command()
@click.argument('rev', default='latest')
def update_mail_receiver(rev):
    """Update discourse-mail-receiver.

    REV: the git rev to update to ('vX.Y.Z') or 'latest'; defaults to
    'latest'.

    """
    repo = DiscourseRepo(repo="mail-receiver")

    if rev == 'latest':
        version = repo.versions[0]
    else:
        version = DiscourseVersion(rev)

    _call_nix_update('discourse-mail-receiver', version.version)


@cli.command()
def update_plugins():
    """Update plugins to their latest revision."""
    plugins = [
        {'name': 'discourse-assign'},
        {'name': 'discourse-bbcode-color'},
        {'name': 'discourse-calendar'},
        {'name': 'discourse-canned-replies'},
        {'name': 'discourse-chat-integration'},
        {'name': 'discourse-checklist'},
        {'name': 'discourse-data-explorer'},
        {'name': 'discourse-docs'},
        {'name': 'discourse-github'},
        {'name': 'discourse-ldap-auth', 'owner': 'jonmbake'},
        {'name': 'discourse-math'},
        {'name': 'discourse-migratepassword', 'owner': 'discoursehosting'},
        {'name': 'discourse-openid-connect'},
        {'name': 'discourse-prometheus'},
        {'name': 'discourse-reactions'},
        {'name': 'discourse-saved-searches'},
        {'name': 'discourse-solved'},
        {'name': 'discourse-spoiler-alert'},
        {'name': 'discourse-voting'},
        {'name': 'discourse-yearly-review'},
    ]

    for plugin in plugins:
        fetcher = plugin.get('fetcher') or "fetchFromGitHub"
        owner = plugin.get('owner') or "discourse"
        name = plugin.get('name')
        repo_name = plugin.get('repo_name') or name

        repo = DiscourseRepo(owner=owner, repo=repo_name)

        # implement the plugin pinning algorithm laid out here:
        # https://meta.discourse.org/t/pinning-plugin-and-theme-versions-for-older-discourse-installs/156971
        # this makes sure we don't upgrade plugins to revisions that
        # are incompatible with the packaged Discourse version
        try:
            compatibility_spec = repo.get_file('.discourse-compatibility', repo.latest_commit_sha)
            versions = [(DiscourseVersion(discourse_version), plugin_rev.strip(' '))
                        for [discourse_version, plugin_rev]
                        in [line.lstrip("< ").split(':')
                            for line
                            in compatibility_spec.splitlines() if line != '']]
            discourse_version = DiscourseVersion(_get_current_package_version('discourse'))
            versions = list(filter(lambda ver: ver[0] >= discourse_version, versions))
            if versions == []:
                rev = repo.latest_commit_sha
            else:
                rev = versions[0][1]
                print(rev)
        except requests.exceptions.HTTPError:
            rev = repo.latest_commit_sha

        filename = _nix_eval(f'builtins.unsafeGetAttrPos "src" discourse.plugins.{name}')
        if filename is None:
            filename = Path(__file__).parent / 'plugins' / name / 'default.nix'
            filename.parent.mkdir()

            has_ruby_deps = False
            for line in repo.get_file('plugin.rb', rev).splitlines():
                if 'gem ' in line:
                    has_ruby_deps = True
                    break

            with open(filename, 'w') as f:
                f.write(textwrap.dedent(f"""
                         {{ lib, mkDiscoursePlugin, fetchFromGitHub }}:

                         mkDiscoursePlugin {{
                           name = "{name}";"""[1:] + ("""
                           bundlerEnvArgs.gemdir = ./.;""" if has_ruby_deps else "") + f"""
                           src = {fetcher} {{
                             owner = "{owner}";
                             repo = "{repo_name}";
                             rev = "replace-with-git-rev";
                             sha256 = "replace-with-sha256";
                           }};
                           meta = with lib; {{
                             homepage = "";
                             maintainers = with maintainers; [ ];
                             license = licenses.mit; # change to the correct license!
                             description = "";
                           }};
                         }}"""))

            all_plugins_filename = Path(__file__).parent / 'plugins' / 'all-plugins.nix'
            with open(all_plugins_filename, 'r+') as f:
                content = f.read()
                pos = -1
                while content[pos] != '}':
                    pos -= 1
                content = content[:pos] + f'  {name} = callPackage ./{name} {{}};' + os.linesep + content[pos:]
                f.seek(0)
                f.write(content)
                f.truncate()

        else:
            filename = filename['file']

        prev_commit_sha = _nix_eval(f'discourse.plugins.{name}.src.rev')

        if prev_commit_sha == rev:
            click.echo(f'Plugin {name} is already at the latest revision')
            continue

        prev_hash = _nix_eval(f'discourse.plugins.{name}.src.outputHash')
        new_hash = subprocess.check_output([
            'nix-universal-prefetch', fetcher,
            '--owner', owner,
            '--repo', repo_name,
            '--rev', rev,
        ], text=True).strip("\n")

        click.echo(f"Update {name}, {prev_commit_sha} -> {rev} in {filename}")

        with open(filename, 'r+') as f:
            content = f.read()
            content = content.replace(prev_commit_sha, rev)
            content = content.replace(prev_hash, new_hash)
            f.seek(0)
            f.write(content)
            f.truncate()

        rubyenv_dir = Path(filename).parent
        gemfile = rubyenv_dir / "Gemfile"
        version_file_regex = re.compile(r'.*File\.expand_path\("\.\./(.*)", __FILE__\)')
        gemfile_text = ''
        plugin_file = repo.get_file('plugin.rb', rev)
        plugin_file = plugin_file.replace(",\n", ", ") # fix split lines
        for line in plugin_file.splitlines():
            if 'gem ' in line:
                line = ','.join(filter(lambda x: ":require_name" not in x, line.split(',')))
                gemfile_text = gemfile_text + line + os.linesep

                version_file_match = version_file_regex.match(line)
                if version_file_match is not None:
                    filename = version_file_match.groups()[0]
                    content = repo.get_file(filename, rev)
                    with open(rubyenv_dir / filename, 'w') as f:
                        f.write(content)

        if len(gemfile_text) > 0:
            if os.path.isfile(gemfile):
                os.remove(gemfile)

            subprocess.check_output(['bundle', 'init'], cwd=rubyenv_dir)
            os.chmod(gemfile, stat.S_IREAD | stat.S_IWRITE | stat.S_IRGRP | stat.S_IROTH)

            with open(gemfile, 'a') as f:
                f.write(gemfile_text)

            subprocess.check_output(['bundle', 'lock', '--add-platform', 'ruby'], cwd=rubyenv_dir)
            subprocess.check_output(['bundle', 'lock', '--update'], cwd=rubyenv_dir)
            _remove_platforms(rubyenv_dir)
            subprocess.check_output(['bundix'], cwd=rubyenv_dir)


if __name__ == '__main__':
    cli()
