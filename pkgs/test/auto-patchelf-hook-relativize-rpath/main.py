from pathlib import Path
import ctypes

lib_path = Path(__file__).parent / "libs/baz-bundle/libbaz.so"
lib = ctypes.CDLL(str(lib_path))

lib.baz.restype = ctypes.c_uint
lib.baz.argtypes = []

lib.baz()
