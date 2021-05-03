#!/usr/bin/env nix-shell
#! nix-shell -i python3 -p bundix bundler nix-update python3 python3Packages.requests python3Packages.click python3Packages.click-log

import click
import click_log
import shutil
import tempfile
import re
import logging
import subprocess
import pathlib
from distutils.version import LooseVersion
from typing import Iterable

import requests

logger = logging.getLogger(__name__)


class DiscourseRepo:
    version_regex = re.compile(r'^v\d+\.\d+\.\d+$')
    def __init__(self, owner: str = 'discourse', repo: str = 'discourse'):
        self.owner = owner
        self.repo = repo

    @property
    def tags(self) -> Iterable[str]:
        r = requests.get(f'https://api.github.com/repos/{self.owner}/{self.repo}/git/refs/tags').json()
        tags = [x['ref'].replace('refs/tags/', '') for x in r]

        # filter out versions not matching version_regex
        versions = list(filter(self.version_regex.match, tags))

        # sort, but ignore v for sorting comparisons
        versions.sort(key=lambda x: LooseVersion(x.replace('v', '')), reverse=True)
        return versions

    @staticmethod
    def rev2version(tag: str) -> str:
        """
        normalize a tag to a version number.
        This obviously isn't very smart if we don't pass something that looks like a tag
        :param tag: the tag to normalize
        :return: a normalized version number
        """
        # strip v prefix
        return re.sub(r'^v', '', tag)

    def get_file(self, filepath, rev):
        """returns file contents at a given rev :param filepath: the path to
        the file, relative to the repo root :param rev: the rev to
        fetch at :return:

        """
        return requests.get(f'https://raw.githubusercontent.com/{self.owner}/{self.repo}/{rev}/{filepath}').text


def _call_nix_update(pkg, version):
    """calls nix-update from nixpkgs root dir"""
    nixpkgs_path = pathlib.Path(__file__).parent / '../../../../'
    return subprocess.check_output(['nix-update', pkg, '--version', version], cwd=nixpkgs_path)


def _get_current_package_version(pkg: str):
    nixpkgs_path = pathlib.Path(__file__).parent / '../../../../'
    return subprocess.check_output(['nix', 'eval', '--raw', f'nixpkgs.{pkg}.version'], text=True)


def _diff_file(filepath: str, old_version: str, new_version: str):
    repo = DiscourseRepo()

    current_dir = pathlib.Path(__file__).parent

    old = repo.get_file(filepath, 'v' + old_version)
    new = repo.get_file(filepath, 'v' + new_version)

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

    click.secho(f'Diff for {filepath} ({old_version} -> {new_version}):', fg='bright_blue', bold=True)
    click.echo(diff_proc.stdout + '\n')
    return


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
        rev = repo.tags[0]

    old_version = _get_current_package_version('discourse')
    new_version = DiscourseRepo.rev2version(rev)

    if reverse:
        old_version, new_version = new_version, old_version

    for f in ['config/nginx.sample.conf', 'config/discourse_defaults.conf']:
        _diff_file(f, old_version, new_version)


@cli.command()
@click.argument('rev', default='latest')
def update(rev):
    """Update gem files and version.

    REV should be the git rev to update to ('vX.Y.Z') or 'latest';
    defaults to 'latest'.

    """
    repo = DiscourseRepo()

    if rev == 'latest':
        rev = repo.tags[0]
    logger.debug(f"Using rev {rev}")

    version = repo.rev2version(rev)
    logger.debug(f"Using version {version}")

    rubyenv_dir = pathlib.Path(__file__).parent / "rubyEnv"

    for fn in ['Gemfile.lock', 'Gemfile']:
        with open(rubyenv_dir / fn, 'w') as f:
            f.write(repo.get_file(fn, rev))

    subprocess.check_output(['bundle', 'lock'], cwd=rubyenv_dir)
    subprocess.check_output(['bundix'], cwd=rubyenv_dir)

    _call_nix_update('discourse', repo.rev2version(rev))


if __name__ == '__main__':
    cli()
