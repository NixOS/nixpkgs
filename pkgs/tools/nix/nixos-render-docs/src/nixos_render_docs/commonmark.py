from collections.abc import Mapping, Sequence
from dataclasses import dataclass
from typing import cast, Optional

from .md import md_escape, md_make_code, Renderer

from markdown_it.token import Token

@dataclass(kw_only=True)
class List:
    next_idx: Optional[int] = None
    compact: bool
    first_item_seen: bool = False

@dataclass
class Par:
    indent: str
    continuing: bool = False

class CommonMarkRenderer(Renderer):
    __output__ = "commonmark"

    _parstack: list[Par]
    _link_stack: list[str]
    _list_stack: list[List]

    def __init__(self, manpage_urls: Mapping[str, str]):
        super().__init__(manpage_urls)
        self._parstack = [ Par("") ]
        self._link_stack = []
        self._list_stack = []

    def _enter_block(self, extra_indent: str) -> None:
        self._parstack.append(Par(self._parstack[-1].indent + extra_indent))
    def _leave_block(self) -> None:
        self._parstack.pop()
        self._parstack[-1].continuing = True
    def _break(self) -> str:
        self._parstack[-1].continuing = True
        return f"\n{self._parstack[-1].indent}"
    def _maybe_parbreak(self) -> str:
        result = f"\n{self._parstack[-1].indent}" * 2 if self._parstack[-1].continuing else ""
        self._parstack[-1].continuing = True
        return result

    def _admonition_open(self, kind: str) -> str:
        pbreak = self._maybe_parbreak()
        self._enter_block("")
        return f"{pbreak}**{kind}:** "
    def _admonition_close(self) -> str:
        self._leave_block()
        return ""

    def _indent_raw(self, s: str) -> str:
        if '\n' not in s:
            return s
        return f"\n{self._parstack[-1].indent}".join(s.splitlines())

    def text(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        self._parstack[-1].continuing = True
        return self._indent_raw(md_escape(token.content))
    def paragraph_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return self._maybe_parbreak()
    def paragraph_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return ""
    def hardbreak(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return f"  {self._break()}"
    def softbreak(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return self._break()
    def code_inline(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        self._parstack[-1].continuing = True
        return md_make_code(token.content)
    def code_block(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return self.fence(token, tokens, i)
    def link_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        self._parstack[-1].continuing = True
        self._link_stack.append(cast(str, token.attrs['href']))
        return "["
    def link_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return f"]({md_escape(self._link_stack.pop())})"
    def list_item_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        lst = self._list_stack[-1]
        lbreak = "" if not lst.first_item_seen else self._break() * (1 if lst.compact else 2)
        lst.first_item_seen = True
        head = " -"
        if lst.next_idx is not None:
            head = f" {lst.next_idx}."
            lst.next_idx += 1
        self._enter_block(" " * (len(head) + 1))
        return f'{lbreak}{head} '
    def list_item_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        self._leave_block()
        return ""
    def bullet_list_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        self._list_stack.append(List(compact=bool(token.meta['compact'])))
        return self._maybe_parbreak()
    def bullet_list_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        self._list_stack.pop()
        return ""
    def em_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return "*"
    def em_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return "*"
    def strong_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return "**"
    def strong_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return "**"
    def fence(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        code = token.content
        if code.endswith('\n'):
            code = code[:-1]
        pbreak = self._maybe_parbreak()
        return pbreak + self._indent_raw(md_make_code(code, info=token.info, multiline=True))
    def blockquote_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        pbreak = self._maybe_parbreak()
        self._enter_block("> ")
        return pbreak + "> "
    def blockquote_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        self._leave_block()
        return ""
    def note_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return self._admonition_open("Note")
    def note_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return self._admonition_close()
    def caution_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return self._admonition_open("Caution")
    def caution_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return self._admonition_close()
    def important_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return self._admonition_open("Important")
    def important_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return self._admonition_close()
    def tip_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return self._admonition_open("Tip")
    def tip_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return self._admonition_close()
    def warning_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return self._admonition_open("Warning")
    def warning_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return self._admonition_close()
    def dl_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        self._list_stack.append(List(compact=False))
        return ""
    def dl_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        self._list_stack.pop()
        return ""
    def dt_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        pbreak = self._maybe_parbreak()
        self._enter_block("   ")
        # add an opening zero-width non-joiner to separate *our* emphasis from possible
        # emphasis in the provided term
        return f'{pbreak} - *{chr(0x200C)}'
    def dt_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return f"{chr(0x200C)}*"
    def dd_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        self._parstack[-1].continuing = True
        return ""
    def dd_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        self._leave_block()
        return ""
    def myst_role(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        self._parstack[-1].continuing = True
        content = md_make_code(token.content)
        if token.meta['name'] == 'manpage' and (url := self._manpage_urls.get(token.content)):
            return f"[{content}]({url})"
        return content # no roles in regular commonmark
    def attr_span_begin(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        # there's no way we can emit attrspans correctly in all cases. we could use inline
        # html for ids, but that would not round-trip. same holds for classes. since this
        # renderer is only used for approximate options export and all of these things are
        # not allowed in options we can ignore them for now.
        return ""
    def attr_span_end(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return ""
    def heading_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return token.markup + " "
    def heading_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return "\n"
    def ordered_list_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        self._list_stack.append(
            List(next_idx = cast(int, token.attrs.get('start', 1)),
                 compact  = bool(token.meta['compact'])))
        return self._maybe_parbreak()
    def ordered_list_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        self._list_stack.pop()
        return ""
