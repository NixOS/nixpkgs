from collections.abc import Mapping, Sequence
from typing import cast, Optional, NamedTuple

from html import escape
from markdown_it.token import Token

from .manual_structure import XrefTarget
from .md import Renderer

class UnresolvedXrefError(Exception):
    pass

class Heading(NamedTuple):
    container_tag: str
    level: int
    html_tag: str
    # special handling for part content: whether partinfo div was already closed from
    # elsewhere or still needs closing.
    partintro_closed: bool
    # tocs are generated when the heading opens, but have to be emitted into the file
    # after the heading titlepage (and maybe partinfo) has been closed.
    toc_fragment: str

_bullet_list_styles = [ 'disc', 'circle', 'square' ]
_ordered_list_styles = [ '1', 'a', 'i', 'A', 'I' ]

class HTMLRenderer(Renderer):
    _xref_targets: Mapping[str, XrefTarget]

    _headings: list[Heading]
    _attrspans: list[str]
    _hlevel_offset: int = 0
    _bullet_list_nesting: int = 0
    _ordered_list_nesting: int = 0

    def __init__(self, manpage_urls: Mapping[str, str], xref_targets: Mapping[str, XrefTarget]):
        super().__init__(manpage_urls)
        self._headings = []
        self._attrspans = []
        self._xref_targets = xref_targets

    def render(self, tokens: Sequence[Token]) -> str:
        result = super().render(tokens)
        result += self._close_headings(None)
        return result

    def text(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return escape(token.content)
    def paragraph_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return "<p>"
    def paragraph_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return "</p>"
    def hardbreak(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return "<br />"
    def softbreak(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return "\n"
    def code_inline(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return f'<code class="literal">{escape(token.content)}</code>'
    def code_block(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return self.fence(token, tokens, i)
    def link_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        href = escape(cast(str, token.attrs['href']), True)
        tag, title, target, text = "link", "", 'target="_top"', ""
        if href.startswith('#'):
            if not (xref := self._xref_targets.get(href[1:])):
                raise UnresolvedXrefError(f"bad local reference, id {href} not known")
            if tokens[i + 1].type == 'link_close':
                tag, text = "xref", xref.title_html
            if xref.title:
                title = f'title="{escape(xref.title, True)}"'
            target, href = "", xref.href()
        return f'<a class="{tag}" href="{href}" {title} {target}>{text}'
    def link_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return "</a>"
    def list_item_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return '<li class="listitem">'
    def list_item_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return "</li>"
    def bullet_list_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        extra = 'compact' if token.meta.get('compact', False) else ''
        style = _bullet_list_styles[self._bullet_list_nesting % len(_bullet_list_styles)]
        self._bullet_list_nesting += 1
        return f'<div class="itemizedlist"><ul class="itemizedlist {extra}" style="list-style-type: {style};">'
    def bullet_list_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        self._bullet_list_nesting -= 1
        return "</ul></div>"
    def em_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return '<span class="emphasis"><em>'
    def em_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return "</em></span>"
    def strong_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return '<span class="strong"><strong>'
    def strong_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return "</strong></span>"
    def fence(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        # TODO use token.info. docbook doesn't so we can't yet.
        return f'<pre class="programlisting">\n{escape(token.content)}</pre>'
    def blockquote_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return '<div class="blockquote"><blockquote class="blockquote">'
    def blockquote_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return "</blockquote></div>"
    def note_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return '<div class="note"><h3 class="title">Note</h3>'
    def note_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return "</div>"
    def caution_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return '<div class="caution"><h3 class="title">Caution</h3>'
    def caution_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return "</div>"
    def important_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return '<div class="important"><h3 class="title">Important</h3>'
    def important_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return "</div>"
    def tip_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return '<div class="tip"><h3 class="title">Tip</h3>'
    def tip_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return "</div>"
    def warning_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return '<div class="warning"><h3 class="title">Warning</h3>'
    def warning_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return "</div>"
    def dl_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return '<div class="variablelist"><dl class="variablelist">'
    def dl_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return "</dl></div>"
    def dt_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return '<dt><span class="term">'
    def dt_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return "</span></dt>"
    def dd_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return "<dd>"
    def dd_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return "</dd>"
    def myst_role(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        if token.meta['name'] == 'command':
            return f'<span class="command"><strong>{escape(token.content)}</strong></span>'
        if token.meta['name'] == 'file':
            return f'<code class="filename">{escape(token.content)}</code>'
        if token.meta['name'] == 'var':
            return f'<code class="varname">{escape(token.content)}</code>'
        if token.meta['name'] == 'env':
            return f'<code class="envar">{escape(token.content)}</code>'
        if token.meta['name'] == 'option':
            return f'<code class="option">{escape(token.content)}</code>'
        if token.meta['name'] == 'manpage':
            [page, section] = [ s.strip() for s in token.content.rsplit('(', 1) ]
            section = section[:-1]
            man = f"{page}({section})"
            title = f'<span class="refentrytitle">{escape(page)}</span>'
            vol = f"({escape(section)})"
            ref = f'<span class="citerefentry">{title}{vol}</span>'
            if man in self._manpage_urls:
                return f'<a class="link" href="{escape(self._manpage_urls[man], True)}" target="_top">{ref}</a>'
            else:
                return ref
        return super().myst_role(token, tokens, i)
    def attr_span_begin(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        # we currently support *only* inline anchors and the special .keycap class to produce
        # keycap-styled spans.
        (id_part, class_part) = ("", "")
        if s := token.attrs.get('id'):
            id_part = f'<a id="{escape(cast(str, s), True)}" />'
        if s := token.attrs.get('class'):
            if s == 'keycap':
                class_part = '<span class="keycap"><strong>'
                self._attrspans.append("</strong></span>")
            else:
                return super().attr_span_begin(token, tokens, i)
        else:
            self._attrspans.append("")
        return id_part + class_part
    def attr_span_end(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return self._attrspans.pop()
    def heading_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        hlevel = int(token.tag[1:])
        htag, hstyle = self._make_hN(hlevel)
        if hstyle:
            hstyle = f'style="{escape(hstyle, True)}"'
        if anchor := cast(str, token.attrs.get('id', '')):
            anchor = f'<a id="{escape(anchor, True)}"></a>'
        result = self._close_headings(hlevel)
        tag = self._heading_tag(token, tokens, i)
        toc_fragment = self._build_toc(tokens, i)
        self._headings.append(Heading(tag, hlevel, htag, tag != 'part', toc_fragment))
        return (
            f'{result}'
            f'<div class="{tag}">'
            f' <div class="titlepage">'
            f'  <div>'
            f'   <div>'
            f'    <{htag} class="title" {hstyle}>'
            f'     {anchor}'
        )
    def heading_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        heading = self._headings[-1]
        result = (
            f'   </{heading.html_tag}>'
            f'  </div>'
            f' </div>'
            f'</div>'
        )
        if heading.container_tag == 'part':
            result += '<div class="partintro">'
        else:
            result += heading.toc_fragment
        return result
    def ordered_list_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        extra = 'compact' if token.meta.get('compact', False) else ''
        start = f'start="{token.attrs["start"]}"' if 'start' in token.attrs else ""
        style = _ordered_list_styles[self._ordered_list_nesting % len(_ordered_list_styles)]
        self._ordered_list_nesting += 1
        return f'<div class="orderedlist"><ol class="orderedlist {extra}" {start} type="{style}">'
    def ordered_list_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        self._ordered_list_nesting -= 1;
        return "</ol></div>"
    def example_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        if id := token.attrs.get('id'):
            return f'<a id="{escape(cast(str, id), True)}" />'
        return ""
    def example_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return ""

    def _make_hN(self, level: int) -> tuple[str, str]:
        return f"h{min(6, max(1, level + self._hlevel_offset))}", ""

    def _maybe_close_partintro(self) -> str:
        if self._headings:
            heading = self._headings[-1]
            if heading.container_tag == 'part' and not heading.partintro_closed:
                self._headings[-1] = heading._replace(partintro_closed=True)
                return heading.toc_fragment + "</div>"
        return ""

    def _close_headings(self, level: Optional[int]) -> str:
        result = []
        while len(self._headings) and (level is None or self._headings[-1].level >= level):
            result.append(self._maybe_close_partintro())
            result.append("</div>")
            self._headings.pop()
        return "\n".join(result)

    def _heading_tag(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return "section"
    def _build_toc(self, tokens: Sequence[Token], i: int) -> str:
        return ""
