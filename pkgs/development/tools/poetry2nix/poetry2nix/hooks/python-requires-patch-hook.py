#!/usr/bin/env python
import ast
import sys
import io


# Python2 compat
if sys.version_info[0] < 3:
    FileNotFoundError = IOError


# Python <= 3.8 compat
def astunparse(tree):
    # Use bundled unparse by default
    if hasattr(ast, "unparse"):
        return ast.unparse(tree)

    # Use example tool from Python sources for older interpreter versions
    from poetry2nix_astunparse import Unparser

    buf = io.StringIO()
    up = Unparser(tree, buf)

    return buf.getvalue()


class Rewriter(ast.NodeVisitor):
    def __init__(self, *args, **kwargs):
        super(Rewriter, self).__init__(*args, **kwargs)
        self.modified = False

    def visit_Call(self, node):
        function_name = ""

        if isinstance(node.func, ast.Name):
            function_name = node.func.id
        elif isinstance(node.func, ast.Attribute):
            function_name = node.func.attr
        else:
            return

        if function_name != "setup":
            return

        for kw in node.keywords:
            if kw.arg != "python_requires":
                continue

            value = kw.value
            if not isinstance(value, ast.Constant):
                return

            # Rewrite version constraints without wildcard characters.
            #
            # Only rewrite the file if the modified value actually differs, as we lose whitespace and comments when rewriting
            # with the AST module.
            python_requires = ", ".join(
                [v.strip().rstrip(".*") for v in value.value.split(",")]
            )
            if value.value != python_requires:
                value.value = python_requires
                self.modified = True


if __name__ == "__main__":
    sys.path.extend(sys.argv[1:])

    try:
        with open("setup.py", encoding="utf-8-sig") as f:
            tree = ast.parse(f.read())
    except FileNotFoundError:
        exit(0)

    r = Rewriter()
    r.visit(tree)

    if r.modified:
        with open("setup.py", "w") as f:
            f.write(astunparse(tree))
