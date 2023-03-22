import argparse
import html
import json
import re
import xml.sax.saxutils as xml

from abc import abstractmethod
from collections.abc import Mapping, Sequence
from pathlib import Path
from typing import Any, cast, ClassVar, Generic, get_args, NamedTuple, Optional, Union

import markdown_it
from markdown_it.token import Token

from . import md, options
from .docbook import DocBookRenderer, Heading, make_xml_id
from .html import HTMLRenderer, UnresolvedXrefError
from .manual_structure import check_structure, FragmentType, is_include, TocEntry, TocEntryType, XrefTarget
from .md import Converter, Renderer
from .utils import Freezeable

class BaseConverter(Converter[md.TR], Generic[md.TR]):
    # per-converter configuration for ns:arg=value arguments to include blocks, following
    # the include type. html converters need something like this to support chunking, or
    # another external method like the chunktocs docbook uses (but block options seem like
    # a much nicer of doing this).
    INCLUDE_ARGS_NS: ClassVar[str]
    INCLUDE_FRAGMENT_ALLOWED_ARGS: ClassVar[set[str]] = set()
    INCLUDE_OPTIONS_ALLOWED_ARGS: ClassVar[set[str]] = set()

    _base_paths: list[Path]
    _current_type: list[TocEntryType]

    def convert(self, infile: Path, outfile: Path) -> None:
        self._base_paths = [ infile ]
        self._current_type = ['book']
        try:
            tokens = self._parse(infile.read_text())
            self._postprocess(infile, outfile, tokens)
            converted = self._renderer.render(tokens)
            outfile.write_text(converted)
        except Exception as e:
            raise RuntimeError(f"failed to render manual {infile}") from e

    def _postprocess(self, infile: Path, outfile: Path, tokens: Sequence[Token]) -> None:
        pass

    def _parse(self, src: str) -> list[Token]:
        tokens = super()._parse(src)
        check_structure(self._current_type[-1], tokens)
        for token in tokens:
            if not is_include(token):
                continue
            directive = token.info[12:].split()
            if not directive:
                continue
            args = { k: v for k, _sep, v in map(lambda s: s.partition('='), directive[1:]) }
            typ = directive[0]
            if typ == 'options':
                token.type = 'included_options'
                self._process_include_args(token, args, self.INCLUDE_OPTIONS_ALLOWED_ARGS)
                self._parse_options(token, args)
            else:
                fragment_type = typ.removesuffix('s')
                if fragment_type not in get_args(FragmentType):
                    raise RuntimeError(f"unsupported structural include type '{typ}'")
                self._current_type.append(cast(FragmentType, fragment_type))
                token.type = 'included_' + typ
                self._process_include_args(token, args, self.INCLUDE_FRAGMENT_ALLOWED_ARGS)
                self._parse_included_blocks(token, args)
                self._current_type.pop()
        return tokens

    def _process_include_args(self, token: Token, args: dict[str, str], allowed: set[str]) -> None:
        ns = self.INCLUDE_ARGS_NS + ":"
        args = { k[len(ns):]: v for k, v in args.items() if k.startswith(ns) }
        if unknown := set(args.keys()) - allowed:
            assert token.map
            raise RuntimeError(f"unrecognized include argument in line {token.map[0] + 1}", unknown)
        token.meta['include-args'] = args

    def _parse_included_blocks(self, token: Token, block_args: dict[str, str]) -> None:
        assert token.map
        included = token.meta['included'] = []
        for (lnum, line) in enumerate(token.content.splitlines(), token.map[0] + 2):
            line = line.strip()
            path = self._base_paths[-1].parent / line
            if path in self._base_paths:
                raise RuntimeError(f"circular include found in line {lnum}")
            try:
                self._base_paths.append(path)
                with open(path, 'r') as f:
                    tokens = self._parse(f.read())
                    included.append((tokens, path))
                self._base_paths.pop()
            except Exception as e:
                raise RuntimeError(f"processing included file {path} from line {lnum}") from e

    def _parse_options(self, token: Token, block_args: dict[str, str]) -> None:
        assert token.map

        items = {}
        for (lnum, line) in enumerate(token.content.splitlines(), token.map[0] + 2):
            if len(args := line.split(":", 1)) != 2:
                raise RuntimeError(f"options directive with no argument in line {lnum}")
            (k, v) = (args[0].strip(), args[1].strip())
            if k in items:
                raise RuntimeError(f"duplicate options directive {k} in line {lnum}")
            items[k] = v
        try:
            id_prefix = items.pop('id-prefix')
            varlist_id = items.pop('list-id')
            source = items.pop('source')
        except KeyError as e:
            raise RuntimeError(f"options directive {e} missing in block at line {token.map[0] + 1}")
        if items.keys():
            raise RuntimeError(
                f"unsupported options directives in block at line {token.map[0] + 1}",
                " ".join(items.keys()))

        try:
            with open(self._base_paths[-1].parent / source, 'r') as f:
                token.meta['id-prefix'] = id_prefix
                token.meta['list-id'] = varlist_id
                token.meta['source'] = json.load(f)
        except Exception as e:
            raise RuntimeError(f"processing options block in line {token.map[0] + 1}") from e

class RendererMixin(Renderer):
    _toplevel_tag: str
    _revision: str

    def __init__(self, toplevel_tag: str, revision: str, *args: Any, **kwargs: Any):
        super().__init__(*args, **kwargs)
        self._toplevel_tag = toplevel_tag
        self._revision = revision
        self.rules |= {
            'included_sections': lambda *args: self._included_thing("section", *args),
            'included_chapters': lambda *args: self._included_thing("chapter", *args),
            'included_preface': lambda *args: self._included_thing("preface", *args),
            'included_parts': lambda *args: self._included_thing("part", *args),
            'included_appendix': lambda *args: self._included_thing("appendix", *args),
            'included_options': self.included_options,
        }

    def render(self, tokens: Sequence[Token]) -> str:
        # books get special handling because they have *two* title tags. doing this with
        # generic code is more complicated than it's worth. the checks above have verified
        # that both titles actually exist.
        if self._toplevel_tag == 'book':
            return self._render_book(tokens)

        return super().render(tokens)

    @abstractmethod
    def _render_book(self, tokens: Sequence[Token]) -> str:
        raise NotImplementedError()

    @abstractmethod
    def _included_thing(self, tag: str, token: Token, tokens: Sequence[Token], i: int) -> str:
        raise NotImplementedError()

    @abstractmethod
    def included_options(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        raise NotImplementedError()

class ManualDocBookRenderer(RendererMixin, DocBookRenderer):
    def __init__(self, toplevel_tag: str, revision: str, manpage_urls: Mapping[str, str]):
        super().__init__(toplevel_tag, revision, manpage_urls)

    def _render_book(self, tokens: Sequence[Token]) -> str:
        assert tokens[1].children
        assert tokens[4].children
        if (maybe_id := cast(str, tokens[0].attrs.get('id', ""))):
            maybe_id = "xml:id=" + xml.quoteattr(maybe_id)
        return (f'<book xmlns="http://docbook.org/ns/docbook"'
                f'      xmlns:xlink="http://www.w3.org/1999/xlink"'
                f'      {maybe_id} version="5.0">'
                f'  <title>{self.renderInline(tokens[1].children)}</title>'
                f'  <subtitle>{self.renderInline(tokens[4].children)}</subtitle>'
                f'  {super(DocBookRenderer, self).render(tokens[6:])}'
                f'</book>')

    def _heading_tag(self, token: Token, tokens: Sequence[Token], i: int) -> tuple[str, dict[str, str]]:
        (tag, attrs) = super()._heading_tag(token, tokens, i)
        # render() has already verified that we don't have supernumerary headings and since the
        # book tag is handled specially we can leave the check this simple
        if token.tag != 'h1':
            return (tag, attrs)
        return (self._toplevel_tag, attrs | {
            'xmlns': "http://docbook.org/ns/docbook",
            'xmlns:xlink': "http://www.w3.org/1999/xlink",
        })

    def _included_thing(self, tag: str, token: Token, tokens: Sequence[Token], i: int) -> str:
        result = []
        # close existing partintro. the generic render doesn't really need this because
        # it doesn't have a concept of structure in the way the manual does.
        if self._headings and self._headings[-1] == Heading('part', 1):
            result.append("</partintro>")
            self._headings[-1] = self._headings[-1]._replace(partintro_closed=True)
        # must nest properly for structural includes. this requires saving at least
        # the headings stack, but creating new renderers is cheap and much easier.
        r = ManualDocBookRenderer(tag, self._revision, self._manpage_urls)
        for (included, path) in token.meta['included']:
            try:
                result.append(r.render(included))
            except Exception as e:
                raise RuntimeError(f"rendering {path}") from e
        return "".join(result)
    def included_options(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        conv = options.DocBookConverter(self._manpage_urls, self._revision, False, 'fragment',
                                        token.meta['list-id'], token.meta['id-prefix'])
        conv.add_options(token.meta['source'])
        return conv.finalize(fragment=True)

    # TODO minimize docbook diffs with existing conversions. remove soon.
    def paragraph_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return super().paragraph_open(token, tokens, i) + "\n "
    def paragraph_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return "\n" + super().paragraph_close(token, tokens, i)
    def code_block(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return f"<programlisting>\n{xml.escape(token.content)}</programlisting>"
    def fence(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        info = f" language={xml.quoteattr(token.info)}" if token.info != "" else ""
        return f"<programlisting{info}>\n{xml.escape(token.content)}</programlisting>"

class DocBookConverter(BaseConverter[ManualDocBookRenderer]):
    INCLUDE_ARGS_NS = "docbook"

    def __init__(self, manpage_urls: Mapping[str, str], revision: str):
        super().__init__()
        self._renderer = ManualDocBookRenderer('book', revision, manpage_urls)


class HTMLParameters(NamedTuple):
    generator: str
    stylesheets: Sequence[str]
    scripts: Sequence[str]
    toc_depth: int
    chunk_toc_depth: int

class ManualHTMLRenderer(RendererMixin, HTMLRenderer):
    _base_path: Path
    _html_params: HTMLParameters

    def __init__(self, toplevel_tag: str, revision: str, html_params: HTMLParameters,
                 manpage_urls: Mapping[str, str], xref_targets: dict[str, XrefTarget],
                 base_path: Path):
        super().__init__(toplevel_tag, revision, manpage_urls, xref_targets)
        self._base_path, self._html_params = base_path, html_params

    def _push(self, tag: str, hlevel_offset: int) -> Any:
        result = (self._toplevel_tag, self._headings, self._attrspans, self._hlevel_offset)
        self._hlevel_offset += hlevel_offset
        self._toplevel_tag, self._headings, self._attrspans = tag, [], []
        return result

    def _pop(self, state: Any) -> None:
        (self._toplevel_tag, self._headings, self._attrspans, self._hlevel_offset) = state

    def _render_book(self, tokens: Sequence[Token]) -> str:
        assert tokens[4].children
        title_id = cast(str, tokens[0].attrs.get('id', ""))
        title = self._xref_targets[title_id].title
        # subtitles don't have IDs, so we can't use xrefs to get them
        subtitle = self.renderInline(tokens[4].children)

        toc = TocEntry.of(tokens[0])
        return "\n".join([
            self._file_header(toc),
            ' <div class="book">',
            '  <div class="titlepage">',
            '   <div>',
            f'   <div><h1 class="title"><a id="{html.escape(title_id, True)}"></a>{title}</h1></div>',
            f'   <div><h2 class="subtitle">{subtitle}</h2></div>',
            '   </div>',
            "   <hr />",
            '  </div>',
            self._build_toc(tokens, 0),
            super(HTMLRenderer, self).render(tokens[6:]),
            ' </div>',
            self._file_footer(toc),
        ])

    def _file_header(self, toc: TocEntry) -> str:
        prev_link, up_link, next_link = "", "", ""
        prev_a, next_a, parent_title = "", "", "&nbsp;"
        home = toc.root
        if toc.prev:
            prev_link = f'<link rel="prev" href="{toc.prev.target.href()}" title="{toc.prev.target.title}" />'
            prev_a = f'<a accesskey="p" href="{toc.prev.target.href()}">Prev</a>'
        if toc.parent:
            up_link = (
                f'<link rel="up" href="{toc.parent.target.href()}" '
                f'title="{toc.parent.target.title}" />'
            )
            if (part := toc.parent) and part.kind != 'book':
                assert part.target.title
                parent_title = part.target.title
        if toc.next:
            next_link = f'<link rel="next" href="{toc.next.target.href()}" title="{toc.next.target.title}" />'
            next_a = f'<a accesskey="n" href="{toc.next.target.href()}">Next</a>'
        return "\n".join([
            '<?xml version="1.0" encoding="utf-8" standalone="no"?>',
            '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"',
            '  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">',
            '<html xmlns="http://www.w3.org/1999/xhtml">',
            ' <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />',
            f' <title>{toc.target.title}</title>',
            "".join((f'<link rel="stylesheet" type="text/css" href="{html.escape(style, True)}" />'
                     for style in self._html_params.stylesheets)),
            "".join((f'<script src="{html.escape(script, True)}" type="text/javascript"></script>'
                     for script in self._html_params.scripts)),
            f' <meta name="generator" content="{html.escape(self._html_params.generator, True)}" />',
            f' <link rel="home" href="{home.target.href()}" title="{home.target.title}" />',
            f' {up_link}{prev_link}{next_link}',
            ' </head>',
            ' <body>',
            '  <div class="navheader">',
            '   <table width="100%" summary="Navigation header">',
            '    <tr>',
            f'    <th colspan="3" align="center">{toc.target.title}</th>',
            '    </tr>',
            '    <tr>',
            f'    <td width="20%" align="left">{prev_a}&nbsp;</td>',
            f'    <th width="60%" align="center">{parent_title}</th>',
            f'    <td width="20%" align="right">&nbsp;{next_a}</td>',
            '    </tr>',
            '   </table>',
            '   <hr />',
            '  </div>',
        ])

    def _file_footer(self, toc: TocEntry) -> str:
        # prev, next = self._get_prev_and_next()
        prev_a, up_a, home_a, next_a = "", "&nbsp;", "&nbsp;", ""
        prev_text, up_text, next_text = "", "", ""
        home = toc.root
        if toc.prev:
            prev_a = f'<a accesskey="p" href="{toc.prev.target.href()}">Prev</a>'
            assert toc.prev.target.title
            prev_text = toc.prev.target.title
        if toc.parent:
            home_a = f'<a accesskey="h" href="{home.target.href()}">Home</a>'
            if toc.parent != home:
                up_a = f'<a accesskey="u" href="{toc.parent.target.href()}">Up</a>'
        if toc.next:
            next_a = f'<a accesskey="n" href="{toc.next.target.href()}">Next</a>'
            assert toc.next.target.title
            next_text = toc.next.target.title
        return "\n".join([
            '  <div class="navfooter">',
            '   <hr />',
            '   <table width="100%" summary="Navigation footer">',
            '    <tr>',
            f'    <td width="40%" align="left">{prev_a}&nbsp;</td>',
            f'    <td width="20%" align="center">{up_a}</td>',
            f'    <td width="40%" align="right">&nbsp;{next_a}</td>',
            '    </tr>',
            '    <tr>',
            f'     <td width="40%" align="left" valign="top">{prev_text}&nbsp;</td>',
            f'     <td width="20%" align="center">{home_a}</td>',
            f'     <td width="40%" align="right" valign="top">&nbsp;{next_text}</td>',
            '    </tr>',
            '   </table>',
            '  </div>',
            ' </body>',
            '</html>',
        ])

    def _heading_tag(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        if token.tag == 'h1':
            return self._toplevel_tag
        return super()._heading_tag(token, tokens, i)
    def _build_toc(self, tokens: Sequence[Token], i: int) -> str:
        toc = TocEntry.of(tokens[i])
        if toc.kind == 'section':
            return ""
        def walk_and_emit(toc: TocEntry, depth: int) -> list[str]:
            if depth <= 0:
                return []
            result = []
            for child in toc.children:
                result.append(
                    f'<dt>'
                    f' <span class="{html.escape(child.kind, True)}">'
                    f'  <a href="{child.target.href()}">{child.target.toc_html}</a>'
                    f' </span>'
                    f'</dt>'
                )
                # we want to look straight through parts because docbook-xsl does too, but it
                # also makes for more uesful top-level tocs.
                next_level = walk_and_emit(child, depth - (0 if child.kind == 'part' else 1))
                if next_level:
                    result.append(f'<dd><dl>{"".join(next_level)}</dl></dd>')
            return result
        toc_depth = (
            self._html_params.chunk_toc_depth
            if toc.starts_new_chunk and toc.kind != 'book'
            else self._html_params.toc_depth
        )
        if not (items := walk_and_emit(toc, toc_depth)):
            return ""
        return (
            f'<div class="toc">'
            f' <p><strong>Table of Contents</strong></p>'
            f' <dl class="toc">'
            f'  {"".join(items)}'
            f' </dl>'
            f'</div>'
        )

    def _make_hN(self, level: int) -> tuple[str, str]:
        # for some reason chapters don't increase the hN nesting count in docbook xslts. duplicate
        # this for consistency.
        if self._toplevel_tag == 'chapter':
            level -= 1
        # TODO docbook compat. these are never useful for us, but not having them breaks manual
        # compare workflows while docbook is still allowed.
        style = ""
        if level + self._hlevel_offset < 3 \
           and (self._toplevel_tag == 'section' or (self._toplevel_tag == 'chapter' and level > 0)):
            style = "clear: both"
        tag, hstyle = super()._make_hN(max(1, level))
        return tag, style

    def _included_thing(self, tag: str, token: Token, tokens: Sequence[Token], i: int) -> str:
        outer, inner = [], []
        # since books have no non-include content the toplevel book wrapper will not count
        # towards nesting depth. other types will have at least a title+id heading which
        # *does* count towards the nesting depth. chapters give a -1 to included sections
        # mirroring the special handing in _make_hN. sigh.
        hoffset = (
            0 if not self._headings
            else self._headings[-1].level - 1 if self._toplevel_tag == 'chapter'
            else self._headings[-1].level
        )
        outer.append(self._maybe_close_partintro())
        into = token.meta['include-args'].get('into-file')
        fragments = token.meta['included']
        state = self._push(tag, hoffset)
        if into:
            toc = TocEntry.of(fragments[0][0][0])
            inner.append(self._file_header(toc))
            # we do not set _hlevel_offset=0 because docbook doesn't either.
        else:
            inner = outer
        for included, path in fragments:
            try:
                inner.append(self.render(included))
            except Exception as e:
                raise RuntimeError(f"rendering {path}") from e
        if into:
            inner.append(self._file_footer(toc))
            (self._base_path / into).write_text("".join(inner))
        self._pop(state)
        return "".join(outer)

    def included_options(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        conv = options.HTMLConverter(self._manpage_urls, self._revision, False,
                                     token.meta['list-id'], token.meta['id-prefix'],
                                     self._xref_targets)
        conv.add_options(token.meta['source'])
        return conv.finalize()

def _to_base26(n: int) -> str:
    return (_to_base26(n // 26) if n > 26 else "") + chr(ord("A") + n % 26)

class HTMLConverter(BaseConverter[ManualHTMLRenderer]):
    INCLUDE_ARGS_NS = "html"
    INCLUDE_FRAGMENT_ALLOWED_ARGS = { 'into-file' }

    _revision: str
    _html_params: HTMLParameters
    _manpage_urls: Mapping[str, str]
    _xref_targets: dict[str, XrefTarget]
    _redirection_targets: set[str]
    _appendix_count: int = 0

    def _next_appendix_id(self) -> str:
        self._appendix_count += 1
        return _to_base26(self._appendix_count - 1)

    def __init__(self, revision: str, html_params: HTMLParameters, manpage_urls: Mapping[str, str]):
        super().__init__()
        self._revision, self._html_params, self._manpage_urls = revision, html_params, manpage_urls
        self._xref_targets = {}
        self._redirection_targets = set()
        # renderer not set on purpose since it has a dependency on the output path!

    def convert(self, infile: Path, outfile: Path) -> None:
        self._renderer = ManualHTMLRenderer('book', self._revision, self._html_params,
                                            self._manpage_urls, self._xref_targets, outfile.parent)
        super().convert(infile, outfile)

    def _parse(self, src: str) -> list[Token]:
        tokens = super()._parse(src)
        for token in tokens:
            if not token.type.startswith('included_') \
               or not (into := token.meta['include-args'].get('into-file')):
                continue
            assert token.map
            if len(token.meta['included']) == 0:
                raise RuntimeError(f"redirection target {into} in line {token.map[0] + 1} is empty!")
            # we use blender-style //path to denote paths relative to the origin file
            # (usually index.html). this makes everything a lot easier and clearer.
            if not into.startswith("//") or '/' in into[2:]:
                raise RuntimeError(f"html:into-file must be a relative-to-origin //filename", into)
            into = token.meta['include-args']['into-file'] = into[2:]
            if into in self._redirection_targets:
                raise RuntimeError(f"redirection target {into} in line {token.map[0] + 1} is already in use")
            self._redirection_targets.add(into)
        return tokens

    # xref | (id, type, heading inlines, file, starts new file)
    def _collect_ids(self, tokens: Sequence[Token], target_file: str, typ: str, file_changed: bool
                     ) -> list[XrefTarget | tuple[str, str, Token, str, bool]]:
        result: list[XrefTarget | tuple[str, str, Token, str, bool]] = []
        # collect all IDs and their xref substitutions. headings are deferred until everything
        # has been parsed so we can resolve links in headings. if that's even used anywhere.
        for (i, bt) in enumerate(tokens):
            if bt.type == 'heading_open' and (id := cast(str, bt.attrs.get('id', ''))):
                result.append((id, typ if bt.tag == 'h1' else 'section', tokens[i + 1], target_file,
                               i == 0 and file_changed))
            elif bt.type == 'included_options':
                id_prefix = bt.meta['id-prefix']
                for opt in bt.meta['source'].keys():
                    id = make_xml_id(f"{id_prefix}{opt}")
                    name = html.escape(opt)
                    result.append(XrefTarget(id, f'<code class="option">{name}</code>', name, None, target_file))
            elif bt.type.startswith('included_'):
                sub_file = bt.meta['include-args'].get('into-file', target_file)
                subtyp = bt.type.removeprefix('included_').removesuffix('s')
                for si, (sub, _path) in enumerate(bt.meta['included']):
                    result += self._collect_ids(sub, sub_file, subtyp, si == 0 and sub_file != target_file)
            elif bt.type == 'inline':
                assert bt.children
                result += self._collect_ids(bt.children, target_file, typ, False)
            elif id := cast(str, bt.attrs.get('id', '')):
                # anchors and examples have no titles we could use, but we'll have to put
                # *something* here to communicate that there's no title.
                result.append(XrefTarget(id, "???", None, None, target_file))
        return result

    def _render_xref(self, id: str, typ: str, inlines: Token, path: str, drop_fragment: bool) -> XrefTarget:
        assert inlines.children
        title_html = self._renderer.renderInline(inlines.children)
        if typ == 'appendix':
            # NOTE the docbook compat is strong here
            n = self._next_appendix_id()
            prefix = f"Appendix\u00A0{n}.\u00A0"
            # HACK for docbook compat: prefix the title inlines with appendix id if
            # necessary. the alternative is to mess with titlepage rendering in headings,
            # which seems just a lot worse than this
            prefix_tokens = [Token(type='text', tag='', nesting=0, content=prefix)]
            inlines.children = prefix_tokens + list(inlines.children)
            title = prefix + title_html
            toc_html = f"{n}. {title_html}"
            title_html = f"Appendix&nbsp;{n}"
        else:
            toc_html, title = title_html, title_html
            title_html = (
                f"<em>{title_html}</em>"
                if typ == 'chapter'
                else title_html if typ in [ 'book', 'part' ]
                else f'the section called “{title_html}”'
            )
        return XrefTarget(id, title_html, toc_html, re.sub('<.*?>', '', title), path, drop_fragment)

    def _postprocess(self, infile: Path, outfile: Path, tokens: Sequence[Token]) -> None:
        xref_queue = self._collect_ids(tokens, outfile.name, 'book', True)

        failed = False
        deferred = []
        while xref_queue:
            for item in xref_queue:
                try:
                    target = item if isinstance(item, XrefTarget) else self._render_xref(*item)
                except UnresolvedXrefError as e:
                    if failed:
                        raise
                    deferred.append(item)
                    continue

                if target.id in self._xref_targets:
                    raise RuntimeError(f"found duplicate id #{target.id}")
                self._xref_targets[target.id] = target
            if len(deferred) == len(xref_queue):
                failed = True # do another round and report the first error
            xref_queue = deferred

        TocEntry.collect_and_link(self._xref_targets, tokens)



def _build_cli_db(p: argparse.ArgumentParser) -> None:
    p.add_argument('--manpage-urls', required=True)
    p.add_argument('--revision', required=True)
    p.add_argument('infile', type=Path)
    p.add_argument('outfile', type=Path)

def _build_cli_html(p: argparse.ArgumentParser) -> None:
    p.add_argument('--manpage-urls', required=True)
    p.add_argument('--revision', required=True)
    p.add_argument('--generator', default='nixos-render-docs')
    p.add_argument('--stylesheet', default=[], action='append')
    p.add_argument('--script', default=[], action='append')
    p.add_argument('--toc-depth', default=1, type=int)
    p.add_argument('--chunk-toc-depth', default=1, type=int)
    p.add_argument('infile', type=Path)
    p.add_argument('outfile', type=Path)

def _run_cli_db(args: argparse.Namespace) -> None:
    with open(args.manpage_urls, 'r') as manpage_urls:
        md = DocBookConverter(json.load(manpage_urls), args.revision)
        md.convert(args.infile, args.outfile)

def _run_cli_html(args: argparse.Namespace) -> None:
    with open(args.manpage_urls, 'r') as manpage_urls:
        md = HTMLConverter(
            args.revision,
            HTMLParameters(args.generator, args.stylesheet, args.script, args.toc_depth,
                           args.chunk_toc_depth),
            json.load(manpage_urls))
        md.convert(args.infile, args.outfile)

def build_cli(p: argparse.ArgumentParser) -> None:
    formats = p.add_subparsers(dest='format', required=True)
    _build_cli_db(formats.add_parser('docbook'))
    _build_cli_html(formats.add_parser('html'))

def run_cli(args: argparse.Namespace) -> None:
    if args.format == 'docbook':
        _run_cli_db(args)
    elif args.format == 'html':
        _run_cli_html(args)
    else:
        raise RuntimeError('format not hooked up', args)
