import os
import subprocess
import sys

__version__ = '@version@'

CMAKE_BIN_DIR = '@CMAKE_BIN_DIR@'

def _program(name, args):
    return subprocess.call([os.path.join(CMAKE_BIN_DIR, name)] + args, close_fds=False)

def cmake():
    raise SystemExit(_program('cmake', sys.argv[1:]))

def cpack():
    raise SystemExit(_program('cpack', sys.argv[1:]))

def ctest():
    raise SystemExit(_program('ctest', sys.argv[1:]))
