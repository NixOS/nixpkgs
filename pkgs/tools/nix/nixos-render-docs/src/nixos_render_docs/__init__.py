import argparse
import os
import sys
from typing import Any, Dict

from .md import Converter
from . import options

def main() -> None:
    parser = argparse.ArgumentParser(description='render nixos manual bits')

    commands = parser.add_subparsers(dest='command', required=True)

    options.build_cli(commands.add_parser('options'))

    args = parser.parse_args()
    if args.command == 'options':
        options.run_cli(args)
    else:
        raise RuntimeError('command not hooked up', args)
