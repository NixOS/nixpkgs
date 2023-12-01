from collections.abc import Mapping, Sequence
from typing import cast, Optional, NamedTuple

from markdown_it.token import Token
from xml.sax.saxutils import escape, quoteattr

from .md import Renderer

_xml_id_translate_table = {
    ord('*'): ord('_'),
    ord('<'): ord('_'),
    ord(' '): ord('_'),
    ord('>'): ord('_'),
    ord('['): ord('_'),
    ord(']'): ord('_'),
    ord(':'): ord('_'),
    ord('"'): ord('_'),
}
def make_xml_id(s: str) -> str:
    return s.translate(_xml_id_translate_table)

class Deflist:
    has_dd = False

class Heading(NamedTuple):
    container_tag: str
    level: int
    # special handling for <part> titles: whether partinfo was already closed from elsewhere
    # or still needs closing.
    partintro_closed: bool = False

class DocBookRenderer(Renderer):
    _link_tags: list[str]
    _deflists: list[Deflist]
    _headings: list[Heading]
    _attrspans: list[str]

    def __init__(self, manpage_urls: Mapping[str, str]):
        super().__init__(manpage_urls)
        self._link_tags = []
        self._deflists = []
        self._headings = []
        self._attrspans = []

    def render(self, tokens: Sequence[Token]) -> str:
        result = super().render(tokens)
        result += self._close_headings(None)
        return result
    def renderInline(self, tokens: Sequence[Token]) -> str:
        # HACK to support docbook links and xrefs. link handling is only necessary because the docbook
        # manpage stylesheet converts - in urls to a mathematical minus, which may be somewhat incorrect.
        for i, token in enumerate(tokens):
            if token.type != 'link_open':
                continue
            token.tag = 'link'
            # turn [](#foo) into xrefs
            if token.attrs['href'][0:1] == '#' and tokens[i + 1].type == 'link_close': # type: ignore[index]
                token.tag = "xref"
            # turn <x> into links without contents
            if tokens[i + 1].type == 'text' and tokens[i + 1].content == token.attrs['href']:
                tokens[i + 1].content = ''

        return super().renderInline(tokens)

    def text(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return escape(token.content)
    def paragraph_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return "<para>"
    def paragraph_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return "</para>"
    def hardbreak(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return "<literallayout>\n</literallayout>"
    def softbreak(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        # should check options.breaks() and emit hard break if so
        return "\n"
    def code_inline(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return f"<literal>{escape(token.content)}</literal>"
    def code_block(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return f"<programlisting>{escape(token.content)}</programlisting>"
    def link_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        self._link_tags.append(token.tag)
        href = cast(str, token.attrs['href'])
        (attr, start) = ('linkend', 1) if href[0] == '#' else ('xlink:href', 0)
        return f"<{token.tag} {attr}={quoteattr(href[start:])}>"
    def link_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return f"</{self._link_tags.pop()}>"
    def list_item_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return "<listitem>"
    def list_item_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return "</listitem>\n"
    # HACK open and close para for docbook change size. remove soon.
    def bullet_list_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        spacing = ' spacing="compact"' if token.meta.get('compact', False) else ''
        return f"<para><itemizedlist{spacing}>\n"
    def bullet_list_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return "\n</itemizedlist></para>"
    def em_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return "<emphasis>"
    def em_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return "</emphasis>"
    def strong_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return "<emphasis role=\"strong\">"
    def strong_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return "</emphasis>"
    def fence(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        info = f" language={quoteattr(token.info)}" if token.info != "" else ""
        return f"<programlisting{info}>{escape(token.content)}</programlisting>"
    def blockquote_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return "<para><blockquote>"
    def blockquote_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return "</blockquote></para>"
    def note_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return "<para><note>"
    def note_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return "</note></para>"
    def caution_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return "<para><caution>"
    def caution_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return "</caution></para>"
    def important_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return "<para><important>"
    def important_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return "</important></para>"
    def tip_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return "<para><tip>"
    def tip_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return "</tip></para>"
    def warning_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return "<para><warning>"
    def warning_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return "</warning></para>"
    # markdown-it emits tokens based on the html syntax tree, but docbook is
    # slightly different. html has <dl>{<dt/>{<dd/>}}</dl>,
    # docbook has <variablelist>{<varlistentry><term/><listitem/></varlistentry>}<variablelist>
    # we have to reject multiple definitions for the same term for time being.
    def dl_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        self._deflists.append(Deflist())
        return "<para><variablelist>"
    def dl_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        self._deflists.pop()
        return "</variablelist></para>"
    def dt_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        self._deflists[-1].has_dd = False
        return "<varlistentry><term>"
    def dt_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return "</term>"
    def dd_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        if self._deflists[-1].has_dd:
            raise Exception("multiple definitions per term not supported")
        self._deflists[-1].has_dd = True
        return "<listitem>"
    def dd_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return "</listitem></varlistentry>"
    def myst_role(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        if token.meta['name'] == 'command':
            return f"<command>{escape(token.content)}</command>"
        if token.meta['name'] == 'file':
            return f"<filename>{escape(token.content)}</filename>"
        if token.meta['name'] == 'var':
            return f"<varname>{escape(token.content)}</varname>"
        if token.meta['name'] == 'env':
            return f"<envar>{escape(token.content)}</envar>"
        if token.meta['name'] == 'option':
            return f"<option>{escape(token.content)}</option>"
        if token.meta['name'] == 'manpage':
            [page, section] = [ s.strip() for s in token.content.rsplit('(', 1) ]
            section = section[:-1]
            man = f"{page}({section})"
            title = f"<refentrytitle>{escape(page)}</refentrytitle>"
            vol = f"<manvolnum>{escape(section)}</manvolnum>"
            ref = f"<citerefentry>{title}{vol}</citerefentry>"
            if man in self._manpage_urls:
                return f"<link xlink:href={quoteattr(self._manpage_urls[man])}>{ref}</link>"
            else:
                return ref
        raise NotImplementedError("md node not supported yet", token)
    def attr_span_begin(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        # we currently support *only* inline anchors and the special .keycap class to produce
        # <keycap> docbook elements.
        (id_part, class_part) = ("", "")
        if s := token.attrs.get('id'):
            id_part = f'<anchor xml:id={quoteattr(cast(str, s))} />'
        if s := token.attrs.get('class'):
            if s == 'keycap':
                class_part = "<keycap>"
                self._attrspans.append("</keycap>")
            else:
                return super().attr_span_begin(token, tokens, i)
        else:
            self._attrspans.append("")
        return id_part + class_part
    def attr_span_end(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return self._attrspans.pop()
    def ordered_list_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        start = f' startingnumber="{token.attrs["start"]}"' if 'start' in token.attrs else ""
        spacing = ' spacing="compact"' if token.meta.get('compact', False) else ''
        return f"<orderedlist{start}{spacing}>"
    def ordered_list_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return "</orderedlist>"
    def heading_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        hlevel = int(token.tag[1:])
        result = self._close_headings(hlevel)
        (tag, attrs) = self._heading_tag(token, tokens, i)
        self._headings.append(Heading(tag, hlevel))
        attrs_str = "".join([ f" {k}={quoteattr(v)}" for k, v in attrs.items() ])
        return result + f'<{tag}{attrs_str}>\n<title>'
    def heading_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        heading = self._headings[-1]
        result = '</title>'
        if heading.container_tag == 'part':
            # generate the same ids as were previously assigned manually. if this collides we
            # rely on outside schema validation to catch it!
            maybe_id = ""
            assert tokens[i - 2].type == 'heading_open'
            if id := cast(str, tokens[i - 2].attrs.get('id', "")):
                maybe_id = " xml:id=" + quoteattr(id + "-intro")
            result += f"<partintro{maybe_id}>"
        return result
    def example_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        if id := cast(str, token.attrs.get('id', '')):
            id = f'xml:id={quoteattr(id)}' if id else ''
        return f'<example {id}>'
    def example_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return "</example>"
    def example_title_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return "<title>"
    def example_title_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return "</title>"

    def _close_headings(self, level: Optional[int]) -> str:
        # we rely on markdown-it producing h{1..6} tags in token.tag for this to work
        result = []
        while len(self._headings):
            if level is None or self._headings[-1].level >= level:
                heading = self._headings.pop()
                if heading.container_tag == 'part' and not heading.partintro_closed:
                    result.append("</partintro>")
                result.append(f"</{heading.container_tag}>")
            else:
                break
        return "\n".join(result)

    def _heading_tag(self, token: Token, tokens: Sequence[Token], i: int) -> tuple[str, dict[str, str]]:
        attrs = {}
        if id := token.attrs.get('id'):
            attrs['xml:id'] = cast(str, id)
        return ("section", attrs)
