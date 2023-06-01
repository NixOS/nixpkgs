import argparse
import os
import sys
import textwrap
import traceback
from io import StringIO
from pprint import pprint
from typing import Any, Dict

from .md import Converter
from . import manual
from . import options
from . import parallel

def pretty_print_exc(e: BaseException, *, _desc_text: str = "error") -> None:
    print(f"\x1b[1;31m{_desc_text}:\x1b[0m", file=sys.stderr)
    # destructure Exception and RuntimeError specifically so we can show nice
    # messages for errors that weren't given their own exception type with
    # a good pretty-printer.
    if type(e) is Exception or type(e) is RuntimeError:
        args = e.args
        if len(args) and isinstance(args[0], str):
            print("\t", args[0], file=sys.stderr, sep="")
            args = args[1:]
        buf = StringIO()
        for arg in args:
            pprint(arg, stream=buf)
        if extra_info := buf.getvalue():
            print(f"\x1b[1;34mextra info:\x1b[0m", file=sys.stderr)
            print(textwrap.indent(extra_info, "\t"), file=sys.stderr, end="")
    else:
        print(e)
    if e.__cause__ is not None:
        print("", file=sys.stderr)
        pretty_print_exc(e.__cause__, _desc_text="caused by")

def main() -> None:
    parser = argparse.ArgumentParser(description='render nixos manual bits')
    parser.add_argument('-j', '--jobs', type=int, default=None)

    commands = parser.add_subparsers(dest='command', required=True)

    options.build_cli(commands.add_parser('options'))
    manual.build_cli(commands.add_parser('manual'))

    args = parser.parse_args()
    try:
        parallel.pool_processes = args.jobs
        if args.command == 'options':
            options.run_cli(args)
        elif args.command == 'manual':
            manual.run_cli(args)
        else:
            raise RuntimeError('command not hooked up', args)
    except Exception as e:
        traceback.print_exc()
        pretty_print_exc(e)
        sys.exit(1)
