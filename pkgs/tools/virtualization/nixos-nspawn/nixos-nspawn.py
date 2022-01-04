#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p "python3.withPackages(ps: with ps; [ rich ])"

#!/usr/bin/env python3

from argparse import ArgumentParser
from configparser import ConfigParser, Interpolation
from glob import glob
from json import dumps, loads
from os import chmod, getenv, makedirs, path, remove, sync
from shutil import rmtree
from subprocess import Popen, PIPE, STDOUT
from sys import exc_info
from traceback import print_tb

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
            'state': self.__machinectl_property('State', 'powered off'),
            'name': self.name,
            'file': self.path,
            'os': self.version
        }

    def type(self):
        return 'imperative' if self.is_imperative() else 'declarative'

    def list_generations(self):
        profile_dir = self.__profile_dir()
        run([
            "nix-env",
            "-p",
            f"{profile_dir}/system",
            "--list-generations"
        ], log_raw=True)

    def rollback(self, strategy=None):
        data = self.__cfg_repr()

        profile_dir = self.__profile_dir()
        run([
            "nix-env",
            "-p",
            f"{profile_dir}/system",
            "--rollback"
        ], log_raw=True)

        self.__activate(
            data=data,
            path=self.__nix_path(),
            strategy=strategy
        )

    def remove(self):
        logging.info(f"Removing {self.name}...")
        run(["machinectl", "poweroff", self.name], must_succeed=False)

        logging.info(f"Removing nspawn unit {self.path}")
        try:
            remove(self.path)
            remove(f'/etc/systemd/network/20-ve-{self.name}.network')
        except FileNotFoundError:
            logging.warn(f"{self.path} or network unit doesn't exist! Continuing with cleanup anyways")

        rmtree(f"{PROFILE_BASE}/{self.name}", ignore_errors=True)

        logging.info(f"Removing state-directory in /var/lib/machines/{self.name}")
        rmtree(f"/var/lib/machines/{self.name}", ignore_errors=True)

    def build_nixos_config(self, nix_expr, update=False, show_trace=False):
        if not update:
            try:
                profile_dir = setup_nixprofile(self.name)
            except FileExistsError:
                raise Exception(
                    f"Profile for {self.name} already exists! Perhaps some dirty state? Try removing with `remove'."
                )
        else:
            profile_dir = self.__profile_dir()

        eval_code = getenv('NIXOS_NSPAWN_EVAL', '@eval@')
        trace_arg = None if not show_trace else "--show-trace"
        args = [
            "nix-env", "-p", f"{profile_dir}/system", "--arg", "config", nix_expr,
            "-f", eval_code, "--set", "--arg", "nixpkgs", "<nixpkgs>"
        ]
        if trace_arg is not None:
            args.append(trace_arg)
        run(args)

        return self.__nix_path()

    def install_container(self, nix_expr, update=False, show_trace=False, strategy=None):
        if not self.pending and not update:
            raise Exception(f"Container {self.name} already exists!")

        path_ = self.build_nixos_config(nix_expr, update, show_trace)
        data = self.__cfg_repr()

        makedirs("/etc/systemd/nspawn", exist_ok=True)

        if data['zone'] is not None and not path.exists(f"/sys/class/net/vz-{data['zone']}"):
            raise Exception(f"Virtual zone {data['zone']} does not exist!")

        zone = "" if data['zone'] is None else f"Zone={data['zone']}"
        ephemeral = "" if not data['ephemeral'] else "Ephemeral=true"
        link_journal = "" if ephemeral != "" else "LinkJournal=guest"
        private_network_text = "" if data['network'] is None else "Private=true\nVirtualEthernet=true"
        port_text = ""
        for p in data['forwardPorts']:
            port_text += f"Port={p}\n"

        if data['network'] is not None and data['zone'] is None:
            network_file = f'/etc/systemd/network/20-ve-{self.name}.network'
            nat_text = "IPMasquerade=yes" if data['network']['v4']['nat'] else ""
            addr_text = ""
            if data['network']['v6']['addrPool'] != []:
                print('Warning: IPv6 SLAAC currently not supported for imperative containers!')

            network_cfgs = [
                data['network']['v4']['addrPool'],
                data['network']['v6']['addrPool'],
                data['network']['v4']['static']['hostAddresses'],
                data['network']['v6']['static']['hostAddresses'],
            ]
            for ips in network_cfgs:
                if ips != []:
                    addr_text += "".join(f"Address={i}\n" for i in ips)

            with open(network_file, 'w+') as f:
                f.write(f"""
[Match]
Driver=veth
Name=ve-{self.name}
[Network]
{addr_text}
DHCPServer=yes
EmitLLDP=customer-bridge
IPForward=yes
{nat_text}
LLDP=yes
""")

            run(["systemctl", "restart", "systemd-networkd"])

        with open(self.path, 'w+') as f:
            f.write(f"""
[Exec]
Boot=false
Parameters={path_}/init
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
{private_network_text}
""")

        logging.info(f"Creating state-directory {self.name}")
        makedirs(f"/var/lib/machines/{self.name}/etc", exist_ok=True)
        if not update:
            open(f"/var/lib/machines/{self.name}/etc/os-release", 'w').close()

        self.pending = False
        sync()

        if update:
            self.__activate(data, path_, strategy)
        else:
            logging.info(f"Booting new container {self.name}")
            run(["machinectl", "start", self.name])

    def __activate(self, data, path, strategy):
        if strategy is None:
            strategy = data['activation']['strategy']
        if strategy == 'restart':
            logging.info(f"Rebooting container {self.name}")
            run(["machinectl", "reboot", self.name])
        else:
            logging.info(f"Reloading container {self.name}")
            pid, _ = run(
                ['machinectl', 'show', self.name, '--property', 'Leader', '--value'],
                return_stdout=True
            )
            run([
                "nsenter",
                "-t",
                pid.strip(),
                "-m",
                "-u",
                "-U",
                "-i",
                "-n",
                "-p",
                "--",
                f"{path}/bin/switch-to-configuration",
                "test"
            ])

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

    def __profile_dir(self):
        return f"{PROFILE_BASE}/{self.name}"

    def __nix_path(self):
        return path.realpath(f"{self.__profile_dir()}/system")

    def __cfg_repr(self):
        with open(f"{self.__nix_path()}/data") as f:
            return loads(f.read())


def create_container(name, expect_imperative=False, pending=False):
    container = Container(
        f"/etc/systemd/nspawn/{name}.nspawn",
        pending=pending
    )

    if expect_imperative and not container.is_imperative():
        raise Exception("Cannot use declarative containers for this operation!")

    return container


def op_create(args):
    new_name = args.name
    create_container(new_name, pending=True).install_container(
        args.config,
        show_trace=args.show_trace
    )


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
    strategy = 'reload' if args.reload else ('restart' if args.restart else None)

    create_container(
        name,
        expect_imperative=True
    ).install_container(cfg, update=True, show_trace=args.show_trace, strategy=strategy)


def op_remove(args):
    try:
        create_container(args.name, expect_imperative=True).remove()
    except Exception as e:
        profile = f"{PROFILE_BASE}/{args.name}"
        if path.exists(profile):
            logging.info(f"Removing leftover profile for {args.name}")
            rmtree(profile, ignore_errors=True)
        else:
            raise e


def op_list_gens(args):
    create_container(args.name, expect_imperative=True).list_generations()


def op_rollback(args):
    strategy = 'reload' if args.reload else ('restart' if args.restart else None)
    create_container(args.name, expect_imperative=True).rollback(strategy=strategy)


if __name__ == '__main__':
    logging.basicConfig(
        level=logging.INFO,
        format='%(asctime)s %(levelname)-8s %(message)s'
    )

    parser = ArgumentParser()
    parser.add_argument('--show-trace', action='store_true')
    cmd = parser.add_subparsers(dest='subcmd')

    # Options to `create` a new imperative container. Apart from the name,
    # a config-file is accepted that's mostly equivalent to how declarative
    # containers are built.
    create = cmd.add_parser('create')
    create.add_argument('name', help='Name of the container')
    create.add_argument('config', help='Configuration file for the container')

    # Options to `list` all containers (either pretty-printed or as json).
    list = cmd.add_parser('list')
    list.add_argument('--declarative', action='store_true')
    list.add_argument('--imperative', action='store_true')
    list.add_argument('--json', action='store_true')

    # Options to `remove` a single, imperative container.
    rm = cmd.add_parser('remove')
    rm.add_argument('name', help='Name of the container')

    # Options to `update` an imperative container by re-applying a Nix
    # expression (as used by `create`) to it.
    update = cmd.add_parser('update')
    update.add_argument('name', help='Name of the container')
    update.add_argument('--reload', help='Whether to reload the container', action='store_true')
    update.add_argument('--restart', help='Whether to restart the container', action='store_true')
    update.add_argument('--config', help='Configuration file to use to update the container')

    # Wrapper for `nix-env --list-generations` on an imperative container.
    list_gens = cmd.add_parser('list-generations')
    list_gens.add_argument('name', help='Name of the container')

    # Wrapper for `nix-env --rollback` on an imperative container.
    rollback = cmd.add_parser('rollback')
    rollback.add_argument('name', help='Name of the container')
    rollback.add_argument('--reload', help='Whether to reload the container', action='store_true')
    rollback.add_argument('--restart', help='Whether to restart the container', action='store_true')

    args = parser.parse_args()
    dst = args.subcmd
    if not args.subcmd:
        dst = "list"
        args.imperative = True
        args.declarative = True
        args.json = False

    cmds = {
        'create': op_create,
        'list': op_list,
        'remove': op_remove,
        'update': op_update,
        'list-generations': op_list_gens,
        'rollback': op_rollback,
    }

    try:
        cmds[dst](args)
    except:
        info = exc_info()
        message = f"Unrecoverable error occurred: {info[0].__name__}({info[1]})"
        logging.error(message)
        if args.show_trace:
            print('Calltrace:')
            print(print_tb(info[2]))
        exit(1)
