import argparse
import json

from abc import abstractmethod
from collections.abc import MutableMapping, Sequence
from markdown_it.utils import OptionsDict
from markdown_it.token import Token
from typing import Any, Optional
from xml.sax.saxutils import escape, quoteattr

from .docbook import DocBookRenderer, make_xml_id
from .md import Converter, md_escape
from .types import OptionLoc, Option, RenderedOption

def option_is(option: Option, key: str, typ: str) -> Optional[dict[str, str]]:
    if key not in option:
        return None
    if type(option[key]) != dict:
        return None
    if option[key].get('_type') != typ: # type: ignore[union-attr]
        return None
    return option[key] # type: ignore[return-value]

class BaseConverter(Converter):
    _options: dict[str, RenderedOption]

    def __init__(self, manpage_urls: dict[str, str],
                 revision: str,
                 document_type: str,
                 varlist_id: str,
                 id_prefix: str,
                 markdown_by_default: bool):
        super().__init__(manpage_urls)
        self._options = {}
        self._revision = revision
        self._document_type = document_type
        self._varlist_id = varlist_id
        self._id_prefix = id_prefix
        self._markdown_by_default = markdown_by_default

    def _format_decl_def_loc(self, loc: OptionLoc) -> tuple[Optional[str], str]:
        # locations can be either plain strings (specific to nixpkgs), or attrsets
        # { name = "foo/bar.nix"; url = "https://github.com/....."; }
        if isinstance(loc, str):
            # Hyperlink the filename either to the NixOS github
            # repository (if it’s a module and we have a revision number),
            # or to the local filesystem.
            if not loc.startswith('/'):
                if self._revision == 'local':
                    href = f"https://github.com/NixOS/nixpkgs/blob/master/{loc}"
                else:
                    href = f"https://github.com/NixOS/nixpkgs/blob/{self._revision}/{loc}"
            else:
                href = f"file://{loc}"
            # Print the filename and make it user-friendly by replacing the
            # /nix/store/<hash> prefix by the default location of nixos
            # sources.
            if not loc.startswith('/'):
                name = f"<nixpkgs/{loc}>"
            elif 'nixops' in loc and '/nix/' in loc:
                name = f"<nixops/{loc[loc.find('/nix/') + 5:]}>"
            else:
                name = loc
            return (href, name)
        else:
            return (loc['url'] if 'url' in loc else None, loc['name'])

    @abstractmethod
    def _decl_def_header(self, header: str) -> list[str]: raise NotImplementedError()

    @abstractmethod
    def _decl_def_entry(self, href: Optional[str], name: str) -> list[str]: raise NotImplementedError()

    @abstractmethod
    def _decl_def_footer(self) -> list[str]: raise NotImplementedError()

    def _render_decl_def(self, header: str, locs: list[OptionLoc]) -> list[str]:
        result = []
        result += self._decl_def_header(header)
        for loc in locs:
            href, name = self._format_decl_def_loc(loc)
            result += self._decl_def_entry(href, name)
        result += self._decl_def_footer()
        return result

    def _render_code(self, option: Option, key: str) -> list[str]:
        if lit := option_is(option, key, 'literalMD'):
            return [ self._render(f"*{key.capitalize()}:*\n{lit['text']}") ]
        elif lit := option_is(option, key, 'literalExpression'):
            code = lit['text']
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
            return [ self._render(f"*{key.capitalize()}:*\n{code}") ]
        elif key in option:
            raise Exception(f"{key} has unrecognized type", option[key])
        else:
            return []

    def _render_description(self, desc: str | dict[str, str]) -> list[str]:
        if isinstance(desc, str) and self._markdown_by_default:
            return [ self._render(desc) ]
        elif isinstance(desc, dict) and desc.get('_type') == 'mdDoc':
            return [ self._render(desc['text']) ]
        else:
            raise Exception("description has unrecognized type", desc)

    @abstractmethod
    def _related_packages_header(self) -> list[str]: raise NotImplementedError()

    def _convert_one(self, option: dict[str, Any]) -> list[str]:
        result = []

        if desc := option.get('description'):
            result += self._render_description(desc)
        if typ := option.get('type'):
            ro = " *(read only)*" if option.get('readOnly', False) else ""
            result.append(self._render(f"*Type:* {md_escape(typ)}{ro}"))

        result += self._render_code(option, 'default')
        result += self._render_code(option, 'example')

        if related := option.get('relatedPackages'):
            result += self._related_packages_header()
            result.append(self._render(related))
        if decl := option.get('declarations'):
            result += self._render_decl_def("Declared by", decl)
        if defs := option.get('definitions'):
            result += self._render_decl_def("Defined by", defs)

        return result

    def add_options(self, options: dict[str, Any]) -> None:
        for (name, option) in options.items():
            try:
                self._options[name] = RenderedOption(option['loc'], self._convert_one(option))
            except Exception as e:
                raise Exception(f"Failed to render option {name}") from e

    @abstractmethod
    def finalize(self) -> str: raise NotImplementedError()

class OptionsDocBookRenderer(DocBookRenderer):
    def heading_open(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                     env: MutableMapping[str, Any]) -> str:
        raise RuntimeError("md token not supported in options doc", token)
    def heading_close(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                      env: MutableMapping[str, Any]) -> str:
        raise RuntimeError("md token not supported in options doc", token)

    # TODO keep optionsDocBook diff small. remove soon if rendering is still good.
    def ordered_list_open(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                          env: MutableMapping[str, Any]) -> str:
        token.attrs['compact'] = False
        return super().ordered_list_open(token, tokens, i, options, env)
    def bullet_list_open(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                         env: MutableMapping[str, Any]) -> str:
        token.attrs['compact'] = False
        return super().bullet_list_open(token, tokens, i, options, env)

class DocBookConverter(BaseConverter):
    __renderer__ = OptionsDocBookRenderer

    def _render_code(self, option: dict[str, Any], key: str) -> list[str]:
        if lit := option_is(option, key, 'literalDocBook'):
            return [ f"<para><emphasis>{key.capitalize()}:</emphasis> {lit['text']}</para>" ]
        else:
            return super()._render_code(option, key)

    def _render_description(self, desc: str | dict[str, Any]) -> list[str]:
        if isinstance(desc, str) and not self._markdown_by_default:
            return [ f"<nixos:option-description><para>{desc}</para></nixos:option-description>" ]
        else:
            return super()._render_description(desc)

    def _related_packages_header(self) -> list[str]:
        return [
            "<para>",
            "  <emphasis>Related packages:</emphasis>",
            "</para>",
        ]

    def _decl_def_header(self, header: str) -> list[str]:
        return [
            f"<para><emphasis>{header}:</emphasis></para>",
            "<simplelist>"
        ]

    def _decl_def_entry(self, href: Optional[str], name: str) -> list[str]:
        if href is not None:
            href = " xlink:href=" + quoteattr(href)
        return [
            f"<member><filename{href}>",
            escape(name),
            "</filename></member>"
        ]

    def _decl_def_footer(self) -> list[str]:
        return [ "</simplelist>" ]

    def finalize(self) -> str:
        keys = list(self._options.keys())
        keys.sort(key=lambda opt: [ (0 if p.startswith("enable") else 1 if p.startswith("package") else 2, p)
                                    for p in self._options[opt].loc ])

        result = []

        result.append('<?xml version="1.0" encoding="UTF-8"?>')
        if self._document_type == 'appendix':
            result += [
                '<appendix xmlns="http://docbook.org/ns/docbook"',
                '          xml:id="appendix-configuration-options">',
                '  <title>Configuration Options</title>',
            ]
        result += [
            f'<variablelist xmlns:xlink="http://www.w3.org/1999/xlink"',
            '               xmlns:nixos="tag:nixos.org"',
            '               xmlns="http://docbook.org/ns/docbook"',
            f'              xml:id="{self._varlist_id}">',
        ]

        for name in keys:
            id = make_xml_id(self._id_prefix + name)
            result += [
                "<varlistentry>",
                # NOTE adding extra spaces here introduces spaces into xref link expansions
                (f"<term xlink:href={quoteattr('#' + id)} xml:id={quoteattr(id)}>" +
                 f"<option>{escape(name)}</option></term>"),
                "<listitem>"
            ]
            result += self._options[name].lines
            result += [
                "</listitem>",
                "</varlistentry>"
            ]

        result.append("</variablelist>")
        if self._document_type == 'appendix':
            result.append("</appendix>")

        return "\n".join(result)

def _build_cli_db(p: argparse.ArgumentParser) -> None:
    p.add_argument('--manpage-urls', required=True)
    p.add_argument('--revision', required=True)
    p.add_argument('--document-type', required=True)
    p.add_argument('--varlist-id', required=True)
    p.add_argument('--id-prefix', required=True)
    p.add_argument('--markdown-by-default', default=False, action='store_true')
    p.add_argument("infile")
    p.add_argument("outfile")

def _run_cli_db(args: argparse.Namespace) -> None:
    with open(args.manpage_urls, 'r') as manpage_urls:
        md = DocBookConverter(
            json.load(manpage_urls),
            revision = args.revision,
            document_type = args.document_type,
            varlist_id = args.varlist_id,
            id_prefix = args.id_prefix,
            markdown_by_default = args.markdown_by_default)

        with open(args.infile, 'r') as f:
            md.add_options(json.load(f))
        with open(args.outfile, 'w') as f:
            f.write(md.finalize())

def build_cli(p: argparse.ArgumentParser) -> None:
    formats = p.add_subparsers(dest='format', required=True)
    _build_cli_db(formats.add_parser('docbook'))

def run_cli(args: argparse.Namespace) -> None:
    if args.format == 'docbook':
        _run_cli_db(args)
    else:
        raise RuntimeError('format not hooked up', args)
