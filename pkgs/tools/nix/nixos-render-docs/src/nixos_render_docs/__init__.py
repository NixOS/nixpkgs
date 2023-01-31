import argparse
import os
import sys
from typing import Any, Dict

from .md import Converter
from . import manual
from . import options

def main() -> None:
    parser = argparse.ArgumentParser(description='render nixos manual bits')

    commands = parser.add_subparsers(dest='command', required=True)

    options.build_cli(commands.add_parser('options'))
    manual.build_cli(commands.add_parser('manual'))

    args = parser.parse_args()
    if args.command == 'options':
        options.run_cli(args)
    elif args.command == 'manual':
        manual.run_cli(args)
    else:
        raise RuntimeError('command not hooked up', args)
