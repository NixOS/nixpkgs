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

from .docbook import make_xml_id, DocBookRenderer
from .md import md_escape

class Converter:
    def __init__(self, manpage_urls: Dict[str, str]):
        self._md = markdown_it.MarkdownIt(
            "commonmark",
            {
                'maxNesting': 100,   # default is 20
                'html': False,       # not useful since we target many formats
                'typographer': True, # required for smartquotes
            },
            renderer_cls=DocBookRenderer
        )
        # TODO maybe fork the plugin and have only a single rule for all?
        self._md.use(container_plugin, name="{.note}")
        self._md.use(container_plugin, name="{.important}")
        self._md.use(container_plugin, name="{.warning}")
        self._md.use(deflist_plugin)
        self._md.use(myst_role_plugin)
        self._md.enable(["smartquotes", "replacements"])

        self._manpage_urls = frozendict(manpage_urls)

    def render(self, src: str) -> str:
        env = {
            'manpage_urls': self._manpage_urls
        }
        return self._md.render(src, env)

md = Converter(json.load(open(os.getenv('MANPAGE_URLS'))))

# converts in-place!
def convertMD(options: Dict[str, Any]) -> str:
    def optionIs(option: Dict[str, Any], key: str, typ: str) -> bool:
        if key not in option: return False
        if type(option[key]) != dict: return False
        if '_type' not in option[key]: return False
        return option[key]['_type'] == typ

    def convertCode(name: str, option: Dict[str, Any], key: str):
        if optionIs(option, key, 'literalMD'):
            option[key] = md.render(f"*{key.capitalize()}:*\n{option[key]['text']}")
        elif optionIs(option, key, 'literalExpression'):
            code = option[key]['text']
            # for multi-line code blocks we only have to count ` runs at the beginning
            # of a line, but this is much easier.
            multiline = '\n' in code
            longest, current = (0, 0)
            for c in code:
                current = current + 1 if c == '`' else 0
                longest = max(current, longest)
            # inline literals need a space to separate ticks from content, code blocks
            # need newlines. inline literals need one extra tick, code blocks need three.
            ticks, sep = ('`' * (longest + (3 if multiline else 1)), '\n' if multiline else ' ')
            code = f"{ticks}{sep}{code}{sep}{ticks}"
            option[key] = md.render(f"*{key.capitalize()}:*\n{code}")
        elif optionIs(option, key, 'literalDocBook'):
            option[key] = f"<para><emphasis>{key.capitalize()}:</emphasis> {option[key]['text']}</para>"
        elif key in option:
            raise Exception(f"{name} {key} has unrecognized type", option[key])

    for (name, option) in options.items():
        try:
            if optionIs(option, 'description', 'mdDoc'):
                option['description'] = md.render(option['description']['text'])
            elif markdownByDefault:
                option['description'] = md.render(option['description'])
            else:
                option['description'] = ("<nixos:option-description><para>" +
                                         option['description'] +
                                         "</para></nixos:option-description>")

            convertCode(name, option, 'example')
            convertCode(name, option, 'default')

            if typ := option.get('type'):
                ro = " *(read only)*" if option.get('readOnly', False) else ""
                option['type'] = md.render(f'*Type:* {md_escape(typ)}{ro}')

            if 'relatedPackages' in option:
                option['relatedPackages'] = md.render(option['relatedPackages'])
        except Exception as e:
            raise Exception(f"Failed to render option {name}") from e

    return options

def need_env(n):
    if n not in os.environ:
        raise RuntimeError("required environment variable not set", n)
    return os.environ[n]

OTD_REVISION = need_env('OTD_REVISION')
OTD_DOCUMENT_TYPE = need_env('OTD_DOCUMENT_TYPE')
OTD_VARIABLE_LIST_ID = need_env('OTD_VARIABLE_LIST_ID')
OTD_OPTION_ID_PREFIX = need_env('OTD_OPTION_ID_PREFIX')

def print_decl_def(header, locs):
    print(f"""<para><emphasis>{header}:</emphasis></para>""")
    print(f"""<simplelist>""")
    for loc in locs:
        # locations can be either plain strings (specific to nixpkgs), or attrsets
        # { name = "foo/bar.nix"; url = "https://github.com/....."; }
        if isinstance(loc, str):
            # Hyperlink the filename either to the NixOS github
            # repository (if it’s a module and we have a revision number),
            # or to the local filesystem.
            if not loc.startswith('/'):
                if OTD_REVISION == 'local':
                    href = f"https://github.com/NixOS/nixpkgs/blob/master/{loc}"
                else:
                    href = f"https://github.com/NixOS/nixpkgs/blob/{OTD_REVISION}/{loc}"
            else:
                href = f"file://{loc}"
            # Print the filename and make it user-friendly by replacing the
            # /nix/store/<hash> prefix by the default location of nixos
            # sources.
            if not loc.startswith('/'):
                name = f"<nixpkgs/{loc}>"
            elif loc.contains('nixops') and loc.contains('/nix/'):
                name = f"<nixops/{loc[loc.find('/nix/') + 5:]}>"
            else:
                name = loc
            print(f"""<member><filename xlink:href={quoteattr(href)}>""")
            print(escape(name))
            print(f"""</filename></member>""")
        else:
            href = f" xlink:href={quoteattr(loc['url'])}" if 'url' in loc else ""
            print(f"""<member><filename{href}>{escape(loc['name'])}</filename></member>""")
    print(f"""</simplelist>""")

def main():
    markdownByDefault = False
    optOffset = 0
    for arg in sys.argv[1:]:
        if arg == "--markdown-by-default":
            optOffset += 1
            markdownByDefault = True

    options = convertMD(json.load(open(sys.argv[1 + optOffset], 'r')))

    keys = list(options.keys())
    keys.sort(key=lambda opt: [ (0 if p.startswith("enable") else 1 if p.startswith("package") else 2, p)
                                for p in options[opt]['loc'] ])

    print(f"""<?xml version="1.0" encoding="UTF-8"?>""")
    if OTD_DOCUMENT_TYPE == 'appendix':
        print("""<appendix xmlns="http://docbook.org/ns/docbook" xml:id="appendix-configuration-options">""")
        print("""  <title>Configuration Options</title>""")
    print(f"""<variablelist xmlns:xlink="http://www.w3.org/1999/xlink"
                            xmlns:nixos="tag:nixos.org"
                            xmlns="http://docbook.org/ns/docbook"
                 xml:id="{OTD_VARIABLE_LIST_ID}">""")

    for name in keys:
        opt = options[name]
        id = OTD_OPTION_ID_PREFIX + make_xml_id(name)
        print(f"""<varlistentry>""")
        # NOTE adding extra spaces here introduces spaces into xref link expansions
        print(f"""<term xlink:href={quoteattr("#" + id)} xml:id={quoteattr(id)}>""", end='')
        print(f"""<option>{escape(name)}</option>""", end='')
        print(f"""</term>""")
        print(f"""<listitem>""")
        print(opt['description'])
        if typ := opt.get('type'):
            print(typ)
        if default := opt.get('default'):
            print(default)
        if example := opt.get('example'):
            print(example)
        if related := opt.get('relatedPackages'):
            print(f"""<para>""")
            print(f"""  <emphasis>Related packages:</emphasis>""")
            print(f"""</para>""")
            print(related)
        if decl := opt.get('declarations'):
            print_decl_def("Declared by", decl)
        if defs := opt.get('definitions'):
            print_decl_def("Defined by", defs)
        print(f"""</listitem>""")
        print(f"""</varlistentry>""")

    print("""</variablelist>""")
    if OTD_DOCUMENT_TYPE == 'appendix':
        print("""</appendix>""")
