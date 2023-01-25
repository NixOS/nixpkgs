import collections
import json
import os
import sys
from collections.abc import MutableMapping, Sequence
from typing import Any, Dict, List
from frozendict import frozendict

# for MD conversion
import markdown_it
import markdown_it.renderer
from markdown_it.token import Token
from markdown_it.utils import OptionsDict
from mdit_py_plugins.container import container_plugin
from mdit_py_plugins.deflist import deflist_plugin
from mdit_py_plugins.myst_role import myst_role_plugin
from xml.sax.saxutils import escape, quoteattr

from .options import DocBookConverter

def need_env(n):
    if n not in os.environ:
        raise RuntimeError("required environment variable not set", n)
    return os.environ[n]

def main():
    markdownByDefault = False
    optOffset = 0
    for arg in sys.argv[1:]:
        if arg == "--markdown-by-default":
            optOffset += 1
            markdownByDefault = True

    md = DocBookConverter(
        json.load(open(os.getenv('MANPAGE_URLS'))),
        revision = need_env('OTD_REVISION'),
        document_type = need_env('OTD_DOCUMENT_TYPE'),
        varlist_id = need_env('OTD_VARIABLE_LIST_ID'),
        id_prefix = need_env('OTD_OPTION_ID_PREFIX'),
        markdown_by_default = markdownByDefault
    )

    options = json.load(open(sys.argv[1 + optOffset], 'r'))
    md.add_options(options)
    print(md.finalize())
