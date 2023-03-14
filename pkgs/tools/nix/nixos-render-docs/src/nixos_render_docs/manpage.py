from collections.abc import Mapping, Sequence
from dataclasses import dataclass
from typing import Any, cast, Iterable, Optional

import re

import markdown_it
from markdown_it.token import Token

from .md import Renderer

# roff(7) says:
#
# > roff documents may contain only graphable 7-bit ASCII characters, the space character,
# > and, in certain circumstances, the tab character. The backslash character ‘\’ indicates
# > the start of an escape sequence […]
#
# mandoc_char(7) says about the `'~^ characters:
#
# > In prose, this automatic substitution is often desirable; but when these characters have
# > to be displayed as plain ASCII characters, for example in source code samples, they require
# > escaping to render as follows:
#
# since we don't want these to be touched anywhere (because markdown will do all substituations
# we want to have) we'll escape those as well. we also escape " (macro metacharacter), - (might
# turn into a typographic hyphen), and . (roff request marker at SOL, changes spacing semantics
# at EOL). groff additionally does not allow unicode escapes for codepoints below U+0080, so
# those need "proper" roff escapes/replacements instead.
_roff_unicode = re.compile(r'''[^\n !#$%&()*+,\-./0-9:;<=>?@A-Z[\\\]_a-z{|}]''', re.ASCII)
_roff_escapes = {
    ord('"'): "\\(dq",
    ord("'"): "\\(aq",
    ord('-'): "\\-",
    ord('.'): "\\&.",
    ord('\\'): "\\e",
    ord('^'): "\\(ha",
    ord('`'): "\\(ga",
    ord('~'): "\\(ti",
}
def man_escape(s: str) -> str:
    s = s.translate(_roff_escapes)
    return _roff_unicode.sub(lambda m: f"\\[u{ord(m[0]):04X}]", s)

# remove leading and trailing spaces from links and condense multiple consecutive spaces
# into a single space for presentation parity with html. this is currently easiest with
# regex postprocessing and some marker characters. since we don't want to drop spaces
# from code blocks we will have to specially protect *inline* code (luckily not block code)
# so normalization can turn the spaces inside it into regular spaces again.
_normalize_space_re = re.compile(r'''\u0000 < *| *>\u0000 |(?<= ) +''')
def _normalize_space(s: str) -> str:
    return _normalize_space_re.sub("", s).replace("\0p", " ")

def _protect_spaces(s: str) -> str:
    return s.replace(" ", "\0p")

@dataclass(kw_only=True)
class List:
    width: int
    next_idx: Optional[int] = None
    compact: bool
    first_item_seen: bool = False

# this renderer assumed that it produces a set of lines as output, and that those lines will
# be pasted as-is into a larger output. no prefixing or suffixing is allowed for correctness.
#
# NOTE that we output exclusively physical markup. this is because we have to use the older
# mandoc(7) format instead of the newer mdoc(7) format due to limitations in groff: while
# using mdoc in groff works fine it is not a native format and thus very slow to render on
# manpages as large as configuration.nix.5. mandoc(1) renders both really quickly, but with
# groff being our predominant manpage viewer we have to optimize for groff instead.
#
# while we do use only physical markup (adjusting indentation with .RS and .RE, adding
# vertical spacing with .sp, \f[BIRP] escapes for bold/italic/roman/$previous font, \h for
# horizontal motion in a line) we do attempt to copy the style of mdoc(7) semantic requests
# as appropriate for each markup element.
class ManpageRenderer(Renderer):
    # whether to emit mdoc .Ql equivalents for inline code or just the contents. this is
    # mainly used by the options manpage converter to not emit extra quotes in defaults
    # and examples where it's already clear from context that the following text is code.
    inline_code_is_quoted: bool = True
    link_footnotes: Optional[list[str]] = None

    _href_targets: dict[str, str]

    _link_stack: list[str]
    _do_parbreak_stack: list[bool]
    _list_stack: list[List]
    _font_stack: list[str]

    def __init__(self, manpage_urls: Mapping[str, str], href_targets: dict[str, str]):
        super().__init__(manpage_urls)
        self._href_targets = href_targets
        self._link_stack = []
        self._do_parbreak_stack = []
        self._list_stack = []
        self._font_stack = []

    def _join_block(self, ls: Iterable[str]) -> str:
        return "\n".join([ l for l in ls if len(l) ])
    def _join_inline(self, ls: Iterable[str]) -> str:
        return _normalize_space(super()._join_inline(ls))

    def _enter_block(self) -> None:
        self._do_parbreak_stack.append(False)
    def _leave_block(self) -> None:
        self._do_parbreak_stack.pop()
        self._do_parbreak_stack[-1] = True
    def _maybe_parbreak(self, suffix: str = "") -> str:
        result = f".sp{suffix}" if self._do_parbreak_stack[-1] else ""
        self._do_parbreak_stack[-1] = True
        return result

    def _admonition_open(self, kind: str) -> str:
        self._enter_block()
        return (
            '.sp\n'
            '.RS 4\n'
            f'\\fB{kind}\\fP\n'
            '.br'
        )
    def _admonition_close(self) -> str:
        self._leave_block()
        return ".RE"

    def render(self, tokens: Sequence[Token]) -> str:
        self._do_parbreak_stack = [ False ]
        self._font_stack = [ "\\fR" ]
        return super().render(tokens)

    def text(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return man_escape(token.content)
    def paragraph_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return self._maybe_parbreak()
    def paragraph_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return ""
    def hardbreak(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return ".br"
    def softbreak(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return " "
    def code_inline(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        s = _protect_spaces(man_escape(token.content))
        return f"\\fR\\(oq{s}\\(cq\\fP" if self.inline_code_is_quoted else s
    def code_block(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return self.fence(token, tokens, i)
    def link_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        href = cast(str, token.attrs['href'])
        self._link_stack.append(href)
        text = ""
        if tokens[i + 1].type == 'link_close' and href in self._href_targets:
            # TODO error or warning if the target can't be resolved
            text = self._href_targets[href]
        self._font_stack.append("\\fB")
        return f"\\fB{text}\0 <"
    def link_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        href = self._link_stack.pop()
        text = ""
        if self.link_footnotes is not None:
            try:
                idx = self.link_footnotes.index(href) + 1
            except ValueError:
                self.link_footnotes.append(href)
                idx = len(self.link_footnotes)
            text = "\\fR" + man_escape(f"[{idx}]")
        self._font_stack.pop()
        return f">\0 {text}{self._font_stack[-1]}"
    def list_item_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        self._enter_block()
        lst = self._list_stack[-1]
        maybe_space = '' if lst.compact or not lst.first_item_seen else '.sp\n'
        lst.first_item_seen = True
        head = "•"
        if lst.next_idx is not None:
            head = f"{lst.next_idx}."
            lst.next_idx += 1
        return (
            f'{maybe_space}'
            f'.RS {lst.width}\n'
            f"\\h'-{len(head) + 1}'\\fB{man_escape(head)}\\fP\\h'1'\\c"
        )
    def list_item_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        self._leave_block()
        return ".RE"
    def bullet_list_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        self._list_stack.append(List(width=4, compact=bool(token.meta['compact'])))
        return self._maybe_parbreak()
    def bullet_list_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        self._list_stack.pop()
        return ""
    def em_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        self._font_stack.append("\\fI")
        return "\\fI"
    def em_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        self._font_stack.pop()
        return self._font_stack[-1]
    def strong_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        self._font_stack.append("\\fB")
        return "\\fB"
    def strong_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        self._font_stack.pop()
        return self._font_stack[-1]
    def fence(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        s = man_escape(token.content).rstrip('\n')
        return (
            '.sp\n'
            '.RS 4\n'
            '.nf\n'
            f'{s}\n'
            '.fi\n'
            '.RE'
        )
    def blockquote_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        maybe_par = self._maybe_parbreak("\n")
        self._enter_block()
        return (
            f"{maybe_par}"
            ".RS 4\n"
            f"\\h'-3'\\fI\\(lq\\(rq\\fP\\h'1'\\c"
        )
    def blockquote_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        self._leave_block()
        return ".RE"
    def note_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return self._admonition_open("Note")
    def note_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return self._admonition_close()
    def caution_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return self._admonition_open( "Caution")
    def caution_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return self._admonition_close()
    def important_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return self._admonition_open( "Important")
    def important_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return self._admonition_close()
    def tip_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return self._admonition_open( "Tip")
    def tip_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return self._admonition_close()
    def warning_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return self._admonition_open( "Warning")
    def warning_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return self._admonition_close()
    def dl_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return ".RS 4"
    def dl_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return ".RE"
    def dt_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return ".PP"
    def dt_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return ""
    def dd_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        self._enter_block()
        return ".RS 4"
    def dd_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        self._leave_block()
        return ".RE"
    def myst_role(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        if token.meta['name'] in [ 'command', 'env', 'option' ]:
            return f'\\fB{man_escape(token.content)}\\fP'
        elif token.meta['name'] in [ 'file', 'var' ]:
            return f'\\fI{man_escape(token.content)}\\fP'
        elif token.meta['name'] == 'manpage':
            [page, section] = [ s.strip() for s in token.content.rsplit('(', 1) ]
            section = section[:-1]
            return f'\\fB{man_escape(page)}\\fP\\fR({man_escape(section)})\\fP'
        else:
            raise NotImplementedError("md node not supported yet", token)
    def attr_span_begin(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        # mdoc knows no anchors so we can drop those, but classes must be rejected.
        if 'class' in token.attrs:
            return super().attr_span_begin(token, tokens, i)
        return ""
    def attr_span_end(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return ""
    def heading_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        raise RuntimeError("md token not supported in manpages", token)
    def heading_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        raise RuntimeError("md token not supported in manpages", token)
    def ordered_list_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        # max item head width for a number, a dot, and one leading space and one trailing space
        width = 3 + len(str(cast(int, token.meta['end'])))
        self._list_stack.append(
            List(width    = width,
                 next_idx = cast(int, token.attrs.get('start', 1)),
                 compact  = bool(token.meta['compact'])))
        return self._maybe_parbreak()
    def ordered_list_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        self._list_stack.pop()
        return ""
