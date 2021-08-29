#!/usr/bin/env nix-shell
#!nix-shell -p python3 -i python3 python3Packages.rich

# TODO
# * support for extra-options
# * refactoring
# * tests
# * polkit
# * activation

from argparse import ArgumentParser
from configparser import ConfigParser, Interpolation
from glob import glob
from json import dumps, loads
from os import chmod, getenv, makedirs, path, remove, sync
from shutil import rmtree
from subprocess import Popen, PIPE, STDOUT
from sys import exc_info

import logging
import re
import rich

# Needed to stop waiting for log output from subprocesses. If a byte-str
# that is empty is returned from there, it implies that the command has
# finished.
POPEN_END_DELIM = b''

# Directory where the config-profiles for the containers will be stored.
PROFILE_BASE = '/nix/var/nix/profiles/per-nspawn'


def run(args, must_succeed=True, return_stdout=False, log_raw=False):
    proc = Popen(args, stdout=PIPE, stderr=STDOUT)
    exit_code = proc.wait()
    if return_stdout:
        ret = str(proc.stdout.read().strip(), 'utf-8')
    else:
        ret = None
        for line in iter(proc.stdout.readline, POPEN_END_DELIM):
            if log_raw:
                print(str(line, 'utf-8').rstrip())
            else:
                logging.info(f"Output from {args[0]}: {str(line, 'utf-8').rstrip()}")

    if exit_code != 0 and must_succeed:
        raise Exception(
            f"Command `{' '.join(args)}` failed with exit code "
            + str(exit_code) + "!"
        )

    return (ret, exit_code)


def setup_nixprofile(name):
    makedirs(f"{PROFILE_BASE}/{name}")
    chmod(PROFILE_BASE, 0o755)

    return f"{PROFILE_BASE}/{name}"


class MyConfigParser(ConfigParser):
    def _join_multiline_values(self):
        pass


class SystemdSettings(dict):
    def __setitem__(self, key, value):
        if key in self:
            existing = self[key]
            if type(existing) != list:
                existing = [existing, value]
            else:
                existing.append(value)
            super(SystemdSettings, self).__setitem__(key, existing)
        else:
            super(SystemdSettings, self).__setitem__(key, value)


class Container:
    def __init__(self, pathname, pending=False):
        if not path.exists(pathname) and not pending:
            raise Exception(f"nspawn unit {pathname} doesn't exist!")

        self.name = path.basename(pathname)[:-len('.nspawn')]
        self.path = pathname

        if not pending:
            self.__build_config()

        if pending and path.exists(pathname):
            raise Exception(f"Container {self.name} already exists!")

        self.pending = pending
        self.version = None

    def should_rendered(self, args):
        if args.imperative == args.declarative:
            return True

        return ((args.imperative and self.is_imperative())
                or (args.declarative and not self.is_imperative()))

    def is_imperative(self):
        if 'X-Imperative' in self.exec:
            return self.exec['X-Imperative'][0] == '1'
        return False

    def render(self):
        kind = self.type()
        out = f"[bold]{self.name}[/bold] "
        out += f"([bold cyan]{self.__machinectl_property('State', 'powered off')}[/bold cyan], "
        out += f"[dim]{kind}[/dim])\n"
        out += f"  File: {self.path}\n"
        out += f"  OS:   [green]{self.os_version()}[/green]\n"

        return out

    def os_version(self):
        if self.version is not None:
            return self.version

        filepath = self.__machinectl_property('RootDirectory', default=None)
        if not filepath:
            return '<unknown>'

        os_release = f"{filepath}/etc/static/os-release"
        data = {}
        with open(os_release) as f:
            ptrn = re.compile("^(?P<prop>[^=]+)=\"?(?P<value>[^\"]+)\"?$")
            for line in f:
                if line.startswith('#'):
                    continue
                match = ptrn.match(line)
                if not match:
                    continue
                data[match.group('prop')] = match.group('value').strip()

        if data == {}:
            return '<unknown>'

        self.version = f"{data['NAME']} {data['VERSION']}"

        return self.version

    def dump(self):
        return {
            'kind': self.type(),
            'state': self.machinectl_property('State', 'powered off'),
            'name': self.name,
            'file': self.path,
            'os': self.version()
        }

    def type(self):
        return 'imperative' if self.is_imperative() else 'declarative'

    def list_generations(self):
        profile_dir = f"{PROFILE_BASE}/{self.name}"
        run([
            "nix-env",
            "-p",
            f"{profile_dir}/system",
            "--list-generations"
        ], log_raw=True)

    def rollback(self):
        profile_dir = f"{PROFILE_BASE}/{self.name}"
        run([
            "nix-env",
            "-p",
            f"{profile_dir}/system",
            "--rollback"
        ], log_raw=True)

    def remove(self):
        if not self.is_imperative():
            raise Exception(f"Cannot remove non-declarative container {self.name}!")

        logging.info(f"Removing {self.name}...")
        run(["machinectl", "poweroff", self.name], must_succeed=False)

        logging.info(f"Removing nspawn unit {self.path}")
        try:
            remove(self.path)
        except FileNotFoundError:
            logging.warn(f"{self.path} doesn't exist! Continuing with cleanup anyways")

        rmtree(f"{PROFILE_BASE}/{self.name}", ignore_errors=True)

        logging.info(f"Removing state-directory in /var/lib/machines/{self.name}")
        rmtree(f"/var/lib/machines/{self.name}", ignore_errors=True)

    def build_nixos_config(self, nix_expr, update=False):
        if not update:
            try:
                profile_dir = setup_nixprofile(self.name)
            except FileExistsError:
                raise Exception(
                    f"Profile for {self.name} already exists! Perhaps some dirty state? Try removing with `remove'."
                )
        else:
            profile_dir = f"{PROFILE_BASE}/{self.name}"

        eval_code = getenv('NIXOS_NSPAWN_EVAL', '@eval@')
        run([
            "nix-env", "-p", f"{profile_dir}/system", "--arg", "config", nix_expr,
            "-f", eval_code, "--set", "--arg", "nixpkgs", "<nixpkgs>"
        ])

        return path.realpath(f"{profile_dir}/system")

    def install_container(self, nix_expr, update=False):
        if not self.pending and not update:
            raise Exception(f"Container {self.name} already exists!")

        path = self.build_nixos_config(nix_expr, update)

        with open(f"{path}/data") as f:
            data = loads(f.read())

        zone = "" if data['zone'] is None else f"Zone={data['zone']}"
        ephemeral = "" if not data['ephemeral'] else "Ephemeral=true"
        link_journal = "" if ephemeral != "" else "LinkJournal=guest"
        port_text = ""
        for p in data['forwardPorts']:
            port_text += f"Port={p}\n"

        if data['network'] is not None:
            network_file = f'/etc/systemd/network/20-ve-{self.name}'
            with open(network_file, 'w+') as f:
                f.write(f"""
[Match]
Driver=veth
Name=ve-{self.name}
[Network]
""")

        with open(self.path, 'w+') as f:
            f.write(f"""
[Exec]
Boot=false
Parameters={path}/init
PrivateUsers=yes
X-ActivationStrategy={data['activation']['strategy']}
X-Imperative=1
{ephemeral}
{link_journal}
[Files]
BindReadOnly=/nix/store
BindReadOnly=/nix/var/nix/db
BindReadOnly=/nix/var/nix/daemon-socket
PrivateUsersChown=yes
[Network]
{zone}
{port_text}
""")

        logging.info(f"Creating state-directory {self.name}")
        makedirs(f"/var/lib/machines/{self.name}/etc", exist_ok=True)
        open(f"/var/lib/machines/{self.name}/etc/os-release", 'w').close()

        self.pending = False
        logging.info(f"Booting new container {self.name}")
        sync()
        run(["machinectl", "start", self.name])

    def __machinectl_property(self, prop, default='<unknown>'):
        str_ret, exit = run(
            ['machinectl', 'show', self.name, '--property', prop, '--value'],
            must_succeed=False,
            return_stdout=True
        )

        if exit != 0:
            return default

        return str_ret

    def __build_config(self):
        def extract(key, config):
            if key in config:
                return config[key]
            return {}

        parser = MyConfigParser(
            dict_type=SystemdSettings,
            strict=False,
            interpolation=Interpolation()
        )
        parser.read(self.path)
        parser.sections()

        self.exec = extract('Exec', parser)
        self.files = extract('Files', parser)
        self.network = extract('Network', parser)


def op_create(args):
    new_name = args.name
    Container(f"/etc/systemd/nspawn/{new_name}.nspawn", pending=True).install_container(args.config)


def op_list(args):
    result = []
    for f in glob('/etc/systemd/nspawn/*.nspawn'):
        container = Container(f)
        if container.should_rendered(args):
            if args.json:
                result.append(container.dump())
            else:
                rich.print(container.render())

    if args.json:
        print(dumps(result))


def op_update(args):
    name = args.name
    cfg = args.config
    container = Container(f"/etc/systemd/nspawn/{name}.nspawn")

    if not container.is_imperative():
        raise Exception("Cannot update declarative containers!")

    container.install_container(cfg, update=True)


def op_remove(args):
    try:
        Container(f'/etc/systemd/nspawn/{args.name}.nspawn').remove()
    except Exception as e:
        profile = f"{PROFILE_BASE}/{args.name}"
        if path.exists(profile):
            logging.info(f"Removing leftover profile for {args.name}")
            rmtree(profile, ignore_errors=True)
        else:
            raise e


def op_list_gens(args):
    name = args.name
    container = Container(f"/etc/systemd/nspawn/{name}.nspawn")

    if not container.is_imperative():
        raise Exception("Cannot update declarative containers!")

    container.list_generations()


def op_rollback(args):
    name = args.name
    container = Container(f"/etc/systemd/nspawn/{name}.nspawn")

    if not container.is_imperative():
        raise Exception("Cannot update declarative containers!")

    container.rollback()


if __name__ == '__main__':
    logging.basicConfig(
        level=logging.INFO,
        format='%(asctime)s %(levelname)-8s %(message)s'
    )
    parser = ArgumentParser()
    cmd = parser.add_subparsers(dest='subcmd')
    create = cmd.add_parser('create')
    create.add_argument('name', help='Name of the container')
    create.add_argument('config', help='Configuration file for the container')
    list = cmd.add_parser('list')
    list.add_argument('--declarative', action='store_true')
    list.add_argument('--imperative', action='store_true')
    list.add_argument('--json', action='store_true')
    rm = cmd.add_parser('remove')
    rm.add_argument('name', help='Name of the container')
    update = cmd.add_parser('update')
    update.add_argument('name', help='Name of the container')
    update.add_argument('--config', help='Configuration file to use to update the container')
    list_gens = cmd.add_parser('list-generations')
    list_gens.add_argument('name', help='Name of the container')
    rollback = cmd.add_parser('rollback')
    rollback.add_argument('name', help='Name of the container')

    args = parser.parse_args()

    cmds = {
        'create': op_create,
        'list': op_list,
        'remove': op_remove,
        'update': op_update,
        'list-generations': op_list_gens,
        'rollback': op_rollback,
    }

    try:
        cmds[args.subcmd](args)
    except:
        info = exc_info()
        message = f"Unrecoverable error occurred: {info[0].__name__}({info[1]})"
        logging.error(message)
        exit(1)
