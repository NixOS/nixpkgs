"""
Rewrite libc/library path references to Nix store paths
Nixpkgs uses a normal patch for this but we need to be less
sensitive to changes between versions.
"""
from textwrap import dedent
import sys
import ast
import os


with open(sys.argv[1]) as f:
    mod = ast.parse(f.read(), "geos.py")


class LibTransformer(ast.NodeTransformer):
    _lgeos_replaced = False

    def visit_If(self, node):
        if ast.unparse(node).startswith("if sys.platform.startswith('linux')"):
            return ast.parse(
                dedent(
                    """
            free = CDLL(%s).free
            free.argtypes = [c_void_p]
            free.restype = None
            """
                )
                % (lambda x: "'" + x + "'" if x else None)(os.environ.get("GEOS_LIBC"))
            )
        return node

    def visit_Assign(self, node):
        _target = node.targets[0]
        if (
            not self._lgeos_replaced
            and isinstance(_target, ast.Name)
            and _target.id == "_lgeos"
        ):
            self._lgeos_replaced = True
            return ast.parse("_lgeos = CDLL('%s')" % os.environ["GEOS_LIBRARY_PATH"])
        return node


with open(sys.argv[1], "w") as f:
    f.write(ast.unparse(LibTransformer().visit(mod)))
