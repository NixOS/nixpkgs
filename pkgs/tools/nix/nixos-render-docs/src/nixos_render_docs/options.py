from __future__ import annotations

import argparse
import json

from abc import abstractmethod
from collections.abc import Mapping, MutableMapping, Sequence
from markdown_it.utils import OptionsDict
from markdown_it.token import Token
from typing import Any, Optional
from xml.sax.saxutils import escape, quoteattr

import markdown_it

from . import parallel
from .docbook import DocBookRenderer, make_xml_id
from .manpage import ManpageRenderer, man_escape
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
    __option_block_separator__: str

    _options: dict[str, RenderedOption]

    def __init__(self, manpage_urls: Mapping[str, str],
                 revision: str,
                 markdown_by_default: bool):
        super().__init__(manpage_urls)
        self._options = {}
        self._revision = revision
        self._markdown_by_default = markdown_by_default

    def _sorted_options(self) -> list[tuple[str, RenderedOption]]:
        keys = list(self._options.keys())
        keys.sort(key=lambda opt: [ (0 if p.startswith("enable") else 1 if p.startswith("package") else 2, p)
                                    for p in self._options[opt].loc ])
        return [ (k, self._options[k]) for k in keys ]

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
            return [ self._render(desc) ] if desc else []
        elif isinstance(desc, dict) and desc.get('_type') == 'mdDoc':
            return [ self._render(desc['text']) ] if desc['text'] else []
        else:
            raise Exception("description has unrecognized type", desc)

    @abstractmethod
    def _related_packages_header(self) -> list[str]: raise NotImplementedError()

    def _convert_one(self, option: dict[str, Any]) -> list[str]:
        blocks: list[list[str]] = []

        if desc := option.get('description'):
            blocks.append(self._render_description(desc))
        if typ := option.get('type'):
            ro = " *(read only)*" if option.get('readOnly', False) else ""
            blocks.append([ self._render(f"*Type:*\n{md_escape(typ)}{ro}") ])

        if option.get('default'):
            blocks.append(self._render_code(option, 'default'))
        if option.get('example'):
            blocks.append(self._render_code(option, 'example'))

        if related := option.get('relatedPackages'):
            blocks.append(self._related_packages_header())
            blocks[-1].append(self._render(related))
        if decl := option.get('declarations'):
            blocks.append(self._render_decl_def("Declared by", decl))
        if defs := option.get('definitions'):
            blocks.append(self._render_decl_def("Defined by", defs))

        for part in [ p for p in blocks[0:-1] if p ]:
            part.append(self.__option_block_separator__)

        return [ l for part in blocks for l in part ]

    # this could return a TState parameter, but that does not allow dependent types and
    # will cause headaches when using BaseConverter as a type bound anywhere. Any is the
    # next best thing we can use, and since this is internal it will be mostly safe.
    @abstractmethod
    def _parallel_render_prepare(self) -> Any: raise NotImplementedError()
    # this should return python 3.11's Self instead to ensure that a prepare+finish
    # round-trip ends up with an object of the same type. for now we'll use BaseConverter
    # since it's good enough so far.
    @classmethod
    @abstractmethod
    def _parallel_render_init_worker(cls, a: Any) -> BaseConverter: raise NotImplementedError()

    def _render_option(self, name: str, option: dict[str, Any]) -> RenderedOption:
        try:
            return RenderedOption(option['loc'], self._convert_one(option))
        except Exception as e:
            raise Exception(f"Failed to render option {name}") from e

    @classmethod
    def _parallel_render_step(cls, s: BaseConverter, a: Any) -> RenderedOption:
        return s._render_option(*a)

    def add_options(self, options: dict[str, Any]) -> None:
        mapped = parallel.map(self._parallel_render_step, options.items(), 100,
                              self._parallel_render_init_worker, self._parallel_render_prepare())
        for (name, option) in zip(options.keys(), mapped):
            self._options[name] = option

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
        token.meta['compact'] = False
        return super().ordered_list_open(token, tokens, i, options, env)
    def bullet_list_open(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                         env: MutableMapping[str, Any]) -> str:
        token.meta['compact'] = False
        return super().bullet_list_open(token, tokens, i, options, env)

class DocBookConverter(BaseConverter):
    __renderer__ = OptionsDocBookRenderer
    __option_block_separator__ = ""

    def __init__(self, manpage_urls: dict[str, str],
                 revision: str,
                 markdown_by_default: bool,
                 document_type: str,
                 varlist_id: str,
                 id_prefix: str):
        super().__init__(manpage_urls, revision, markdown_by_default)
        self._document_type = document_type
        self._varlist_id = varlist_id
        self._id_prefix = id_prefix

    def _parallel_render_prepare(self) -> Any:
        return (self._manpage_urls, self._revision, self._markdown_by_default, self._document_type,
                self._varlist_id, self._id_prefix)
    @classmethod
    def _parallel_render_init_worker(cls, a: Any) -> DocBookConverter:
        return cls(*a)

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

    def finalize(self, *, fragment: bool = False) -> str:
        result = []

        if not fragment:
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

        for (name, opt) in self._sorted_options():
            id = make_xml_id(self._id_prefix + name)
            result += [
                "<varlistentry>",
                # NOTE adding extra spaces here introduces spaces into xref link expansions
                (f"<term xlink:href={quoteattr('#' + id)} xml:id={quoteattr(id)}>" +
                 f"<option>{escape(name)}</option></term>"),
                "<listitem>"
            ]
            result += opt.lines
            result += [
                "</listitem>",
                "</varlistentry>"
            ]

        result.append("</variablelist>")
        if self._document_type == 'appendix':
            result.append("</appendix>")

        return "\n".join(result)

class OptionsManpageRenderer(ManpageRenderer):
    pass

class ManpageConverter(BaseConverter):
    def __renderer__(self, manpage_urls: Mapping[str, str],
                     parser: Optional[markdown_it.MarkdownIt] = None) -> OptionsManpageRenderer:
        return OptionsManpageRenderer(manpage_urls, self._options_by_id, parser)

    __option_block_separator__ = ".sp"

    _options_by_id: dict[str, str]
    _links_in_last_description: Optional[list[str]] = None

    def __init__(self, revision: str, markdown_by_default: bool,
                 *,
                 # only for parallel rendering
                 _options_by_id: Optional[dict[str, str]] = None):
        self._options_by_id = _options_by_id or {}
        super().__init__({}, revision, markdown_by_default)

    def _parallel_render_prepare(self) -> Any:
        return ((self._revision, self._markdown_by_default), { '_options_by_id': self._options_by_id })
    @classmethod
    def _parallel_render_init_worker(cls, a: Any) -> ManpageConverter:
        return cls(*a[0], **a[1])

    def _render_option(self, name: str, option: dict[str, Any]) -> RenderedOption:
        assert isinstance(self._md.renderer, OptionsManpageRenderer)
        links = self._md.renderer.link_footnotes = []
        result = super()._render_option(name, option)
        self._md.renderer.link_footnotes = None
        return result._replace(links=links)

    def add_options(self, options: dict[str, Any]) -> None:
        for (k, v) in options.items():
            self._options_by_id[f'#{make_xml_id(f"opt-{k}")}'] = k
        return super().add_options(options)

    def _render_code(self, option: dict[str, Any], key: str) -> list[str]:
        if lit := option_is(option, key, 'literalDocBook'):
            raise RuntimeError("can't render manpages in the presence of docbook")
        else:
            assert isinstance(self._md.renderer, OptionsManpageRenderer)
            try:
                self._md.renderer.inline_code_is_quoted = False
                return super()._render_code(option, key)
            finally:
                self._md.renderer.inline_code_is_quoted = True

    def _render_description(self, desc: str | dict[str, Any]) -> list[str]:
        if isinstance(desc, str) and not self._markdown_by_default:
            raise RuntimeError("can't render manpages in the presence of docbook")
        else:
            return super()._render_description(desc)

    def _related_packages_header(self) -> list[str]:
        return [
            '\\fIRelated packages:\\fP',
            '.sp',
        ]

    def _decl_def_header(self, header: str) -> list[str]:
        return [
            f'\\fI{man_escape(header)}:\\fP',
        ]

    def _decl_def_entry(self, href: Optional[str], name: str) -> list[str]:
        return [
            '.RS 4',
            f'\\fB{man_escape(name)}\\fP',
            '.RE'
        ]

    def _decl_def_footer(self) -> list[str]:
        return []

    def finalize(self) -> str:
        result = []

        result += [
            r'''.TH "CONFIGURATION\&.NIX" "5" "01/01/1980" "NixOS" "NixOS Reference Pages"''',
            r'''.\" disable hyphenation''',
            r'''.nh''',
            r'''.\" disable justification (adjust text to left margin only)''',
            r'''.ad l''',
            r'''.\" enable line breaks after slashes''',
            r'''.cflags 4 /''',
            r'''.SH "NAME"''',
            self._render('{file}`configuration.nix` - NixOS system configuration specification'),
            r'''.SH "DESCRIPTION"''',
            r'''.PP''',
            self._render('The file {file}`/etc/nixos/configuration.nix` contains the '
                        'declarative specification of your NixOS system configuration. '
                        'The command {command}`nixos-rebuild` takes this file and '
                        'realises the system configuration specified therein.'),
            r'''.SH "OPTIONS"''',
            r'''.PP''',
            self._render('You can use the following options in {file}`configuration.nix`.'),
        ]

        for (name, opt) in self._sorted_options():
            result += [
                ".PP",
                f"\\fB{man_escape(name)}\\fR",
                ".RS 4",
            ]
            result += opt.lines
            if links := opt.links:
                result.append(self.__option_block_separator__)
                md_links = ""
                for i in range(0, len(links)):
                    md_links += "\n" if i > 0 else ""
                    if links[i].startswith('#opt-'):
                        md_links += f"{i+1}. see the {{option}}`{self._options_by_id[links[i]]}` option"
                    else:
                        md_links += f"{i+1}. " + md_escape(links[i])
                result.append(self._render(md_links))

            result.append(".RE")

        result += [
            r'''.SH "AUTHORS"''',
            r'''.PP''',
            r'''Eelco Dolstra and the Nixpkgs/NixOS contributors''',
        ]

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

def _build_cli_manpage(p: argparse.ArgumentParser) -> None:
    p.add_argument('--revision', required=True)
    p.add_argument("infile")
    p.add_argument("outfile")

def _run_cli_db(args: argparse.Namespace) -> None:
    with open(args.manpage_urls, 'r') as manpage_urls:
        md = DocBookConverter(
            json.load(manpage_urls),
            revision = args.revision,
            markdown_by_default = args.markdown_by_default,
            document_type = args.document_type,
            varlist_id = args.varlist_id,
            id_prefix = args.id_prefix)

        with open(args.infile, 'r') as f:
            md.add_options(json.load(f))
        with open(args.outfile, 'w') as f:
            f.write(md.finalize())

def _run_cli_manpage(args: argparse.Namespace) -> None:
    md = ManpageConverter(
        revision = args.revision,
        # manpage rendering only works if there's no docbook, so we can
        # also set markdown_by_default with no ill effects.
        markdown_by_default = True)

    with open(args.infile, 'r') as f:
        md.add_options(json.load(f))
    with open(args.outfile, 'w') as f:
        f.write(md.finalize())

def build_cli(p: argparse.ArgumentParser) -> None:
    formats = p.add_subparsers(dest='format', required=True)
    _build_cli_db(formats.add_parser('docbook'))
    _build_cli_manpage(formats.add_parser('manpage'))

def run_cli(args: argparse.Namespace) -> None:
    if args.format == 'docbook':
        _run_cli_db(args)
    elif args.format == 'manpage':
        _run_cli_manpage(args)
    else:
        raise RuntimeError('format not hooked up', args)
