from abc import ABC
from collections.abc import Mapping, MutableMapping, Sequence
from frozendict import frozendict # type: ignore[attr-defined]
from typing import Any, Callable, Optional

import re

from .types import RenderFn

import markdown_it
from markdown_it.token import Token
from markdown_it.utils import OptionsDict
from mdit_py_plugins.container import container_plugin # type: ignore[attr-defined]
from mdit_py_plugins.deflist import deflist_plugin # type: ignore[attr-defined]
from mdit_py_plugins.myst_role import myst_role_plugin # type: ignore[attr-defined]

_md_escape_table = {
    ord('*'): '\\*',
    ord('<'): '\\<',
    ord('['): '\\[',
    ord('`'): '\\`',
    ord('.'): '\\.',
    ord('#'): '\\#',
    ord('&'): '\\&',
    ord('\\'): '\\\\',
}
def md_escape(s: str) -> str:
    return s.translate(_md_escape_table)

class Renderer(markdown_it.renderer.RendererProtocol):
    _admonitions: dict[str, tuple[RenderFn, RenderFn]]
    _admonition_stack: list[str]

    def __init__(self, manpage_urls: Mapping[str, str], parser: Optional[markdown_it.MarkdownIt] = None):
        self._manpage_urls = manpage_urls
        self.rules = {
            'text': self.text,
            'paragraph_open': self.paragraph_open,
            'paragraph_close': self.paragraph_close,
            'hardbreak': self.hardbreak,
            'softbreak': self.softbreak,
            'code_inline': self.code_inline,
            'code_block': self.code_block,
            'link_open': self.link_open,
            'link_close': self.link_close,
            'list_item_open': self.list_item_open,
            'list_item_close': self.list_item_close,
            'bullet_list_open': self.bullet_list_open,
            'bullet_list_close': self.bullet_list_close,
            'em_open': self.em_open,
            'em_close': self.em_close,
            'strong_open': self.strong_open,
            'strong_close': self.strong_close,
            'fence': self.fence,
            'blockquote_open': self.blockquote_open,
            'blockquote_close': self.blockquote_close,
            'dl_open': self.dl_open,
            'dl_close': self.dl_close,
            'dt_open': self.dt_open,
            'dt_close': self.dt_close,
            'dd_open': self.dd_open,
            'dd_close': self.dd_close,
            'myst_role': self.myst_role,
            "container_admonition_open": self.admonition_open,
            "container_admonition_close": self.admonition_close,
            "inline_anchor": self.inline_anchor,
            "heading_open": self.heading_open,
            "heading_close": self.heading_close,
            "ordered_list_open": self.ordered_list_open,
            "ordered_list_close": self.ordered_list_close,
        }

        self._admonitions = {
            "{.note}": (self.note_open, self.note_close),
            "{.caution}": (self.caution_open,self.caution_close),
            "{.tip}": (self.tip_open, self.tip_close),
            "{.important}": (self.important_open, self.important_close),
            "{.warning}": (self.warning_open, self.warning_close),
        }
        self._admonition_stack = []

    def admonition_open(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                        env: MutableMapping[str, Any]) -> str:
        tag = token.info.strip()
        self._admonition_stack.append(tag)
        return self._admonitions[tag][0](token, tokens, i, options, env)
    def admonition_close(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                         env: MutableMapping[str, Any]) -> str:
        return self._admonitions[self._admonition_stack.pop()][1](token, tokens, i, options, env)

    def render(self, tokens: Sequence[Token], options: OptionsDict,
               env: MutableMapping[str, Any]) -> str:
        def do_one(i: int, token: Token) -> str:
            if token.type == "inline":
                assert token.children is not None
                return self.renderInline(token.children, options, env)
            elif token.type in self.rules:
                return self.rules[token.type](tokens[i], tokens, i, options, env)
            else:
                raise NotImplementedError("md token not supported yet", token)
        return "".join(map(lambda arg: do_one(*arg), enumerate(tokens)))
    def renderInline(self, tokens: Sequence[Token], options: OptionsDict,
                     env: MutableMapping[str, Any]) -> str:
        def do_one(i: int, token: Token) -> str:
            if token.type in self.rules:
                return self.rules[token.type](tokens[i], tokens, i, options, env)
            else:
                raise NotImplementedError("md token not supported yet", token)
        return "".join(map(lambda arg: do_one(*arg), enumerate(tokens)))

    def text(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
             env: MutableMapping[str, Any]) -> str:
        raise RuntimeError("md token not supported", token)
    def paragraph_open(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                       env: MutableMapping[str, Any]) -> str:
        raise RuntimeError("md token not supported", token)
    def paragraph_close(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                        env: MutableMapping[str, Any]) -> str:
        raise RuntimeError("md token not supported", token)
    def hardbreak(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                  env: MutableMapping[str, Any]) -> str:
        raise RuntimeError("md token not supported", token)
    def softbreak(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                  env: MutableMapping[str, Any]) -> str:
        raise RuntimeError("md token not supported", token)
    def code_inline(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                    env: MutableMapping[str, Any]) -> str:
        raise RuntimeError("md token not supported", token)
    def code_block(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                   env: MutableMapping[str, Any]) -> str:
        raise RuntimeError("md token not supported", token)
    def link_open(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                  env: MutableMapping[str, Any]) -> str:
        raise RuntimeError("md token not supported", token)
    def link_close(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                   env: MutableMapping[str, Any]) -> str:
        raise RuntimeError("md token not supported", token)
    def list_item_open(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                       env: MutableMapping[str, Any]) -> str:
        raise RuntimeError("md token not supported", token)
    def list_item_close(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                        env: MutableMapping[str, Any]) -> str:
        raise RuntimeError("md token not supported", token)
    def bullet_list_open(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                         env: MutableMapping[str, Any]) -> str:
        raise RuntimeError("md token not supported", token)
    def bullet_list_close(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                          env: MutableMapping[str, Any]) -> str:
        raise RuntimeError("md token not supported", token)
    def em_open(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                env: MutableMapping[str, Any]) -> str:
        raise RuntimeError("md token not supported", token)
    def em_close(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                 env: MutableMapping[str, Any]) -> str:
        raise RuntimeError("md token not supported", token)
    def strong_open(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                    env: MutableMapping[str, Any]) -> str:
        raise RuntimeError("md token not supported", token)
    def strong_close(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                     env: MutableMapping[str, Any]) -> str:
        raise RuntimeError("md token not supported", token)
    def fence(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
              env: MutableMapping[str, Any]) -> str:
        raise RuntimeError("md token not supported", token)
    def blockquote_open(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                        env: MutableMapping[str, Any]) -> str:
        raise RuntimeError("md token not supported", token)
    def blockquote_close(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                         env: MutableMapping[str, Any]) -> str:
        raise RuntimeError("md token not supported", token)
    def note_open(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                  env: MutableMapping[str, Any]) -> str:
        raise RuntimeError("md token not supported", token)
    def note_close(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                   env: MutableMapping[str, Any]) -> str:
        raise RuntimeError("md token not supported", token)
    def caution_open(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                     env: MutableMapping[str, Any]) -> str:
        raise RuntimeError("md token not supported", token)
    def caution_close(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                      env: MutableMapping[str, Any]) -> str:
        raise RuntimeError("md token not supported", token)
    def important_open(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                       env: MutableMapping[str, Any]) -> str:
        raise RuntimeError("md token not supported", token)
    def important_close(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                        env: MutableMapping[str, Any]) -> str:
        raise RuntimeError("md token not supported", token)
    def tip_open(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                 env: MutableMapping[str, Any]) -> str:
        raise RuntimeError("md token not supported", token)
    def tip_close(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                  env: MutableMapping[str, Any]) -> str:
        raise RuntimeError("md token not supported", token)
    def warning_open(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                     env: MutableMapping[str, Any]) -> str:
        raise RuntimeError("md token not supported", token)
    def warning_close(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                      env: MutableMapping[str, Any]) -> str:
        raise RuntimeError("md token not supported", token)
    def dl_open(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                env: MutableMapping[str, Any]) -> str:
        raise RuntimeError("md token not supported", token)
    def dl_close(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                 env: MutableMapping[str, Any]) -> str:
        raise RuntimeError("md token not supported", token)
    def dt_open(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                env: MutableMapping[str, Any]) -> str:
        raise RuntimeError("md token not supported", token)
    def dt_close(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                 env: MutableMapping[str, Any]) -> str:
        raise RuntimeError("md token not supported", token)
    def dd_open(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                env: MutableMapping[str, Any]) -> str:
        raise RuntimeError("md token not supported", token)
    def dd_close(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                 env: MutableMapping[str, Any]) -> str:
        raise RuntimeError("md token not supported", token)
    def myst_role(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                  env: MutableMapping[str, Any]) -> str:
        raise RuntimeError("md token not supported", token)
    def inline_anchor(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                      env: MutableMapping[str, Any]) -> str:
        raise RuntimeError("md token not supported", token)
    def heading_open(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                     env: MutableMapping[str, Any]) -> str:
        raise RuntimeError("md token not supported", token)
    def heading_close(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                      env: MutableMapping[str, Any]) -> str:
        raise RuntimeError("md token not supported", token)
    def ordered_list_open(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                          env: MutableMapping[str, Any]) -> str:
        raise RuntimeError("md token not supported", token)
    def ordered_list_close(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                           env: MutableMapping[str, Any]) -> str:
        raise RuntimeError("md token not supported", token)

def _is_escaped(src: str, pos: int) -> bool:
    found = 0
    while pos >= 0 and src[pos] == '\\':
        found += 1
        pos -= 1
    return found % 2 == 1

_INLINE_ANCHOR_PATTERN = re.compile(r"\{\s*#([\w-]+)\s*\}")

def _inline_anchor_plugin(md: markdown_it.MarkdownIt) -> None:
    def inline_anchor(state: markdown_it.rules_inline.StateInline, silent: bool) -> bool:
        if state.src[state.pos] != '[':
            return False
        if _is_escaped(state.src, state.pos - 1):
            return False

        # treat the inline span like a link label for simplicity.
        label_begin = state.pos + 1
        label_end = markdown_it.helpers.parseLinkLabel(state, state.pos)
        input_end = state.posMax
        if label_end < 0:
            return False

        # match id
        match = _INLINE_ANCHOR_PATTERN.match(state.src[label_end + 1 : ])
        if not match:
            return False

        if not silent:
            token = state.push("inline_anchor", "", 0) # type: ignore[no-untyped-call]
            token.attrs['id'] = match[1]

            state.pos = label_begin
            state.posMax = label_end
            state.md.inline.tokenize(state)

        state.pos = label_end + match.end() + 1
        state.posMax = input_end
        return True

    md.inline.ruler.before("link", "inline_anchor", inline_anchor)

def _inline_comment_plugin(md: markdown_it.MarkdownIt) -> None:
    def inline_comment(state: markdown_it.rules_inline.StateInline, silent: bool) -> bool:
        if state.src[state.pos : state.pos + 4] != '<!--':
            return False
        if _is_escaped(state.src, state.pos - 1):
            return False
        for i in range(state.pos + 4, state.posMax - 2):
            if state.src[i : i + 3] == '-->': # -->
                state.pos = i + 3
                return True

        return False

    md.inline.ruler.after("autolink", "inline_comment", inline_comment)

def _block_comment_plugin(md: markdown_it.MarkdownIt) -> None:
    def block_comment(state: markdown_it.rules_block.StateBlock, startLine: int, endLine: int,
                      silent: bool) -> bool:
        pos = state.bMarks[startLine] + state.tShift[startLine]
        posMax = state.eMarks[startLine]

        if state.src[pos : pos + 4] != '<!--':
            return False

        nextLine = startLine
        while nextLine < endLine:
            pos = state.bMarks[nextLine] + state.tShift[nextLine]
            posMax = state.eMarks[nextLine]

            if state.src[posMax - 3 : posMax] == '-->':
                state.line = nextLine + 1
                return True

            nextLine += 1

        return False

    md.block.ruler.after("code", "block_comment", block_comment)

_HEADER_ID_RE = re.compile(r"\s*\{\s*\#([\w-]+)\s*\}\s*$")

class Converter(ABC):
    __renderer__: Callable[[Mapping[str, str], markdown_it.MarkdownIt], Renderer]

    def __init__(self, manpage_urls: Mapping[str, str]):
        self._manpage_urls = frozendict(manpage_urls)

        self._md = markdown_it.MarkdownIt(
            "commonmark",
            {
                'maxNesting': 100,   # default is 20
                'html': False,       # not useful since we target many formats
                'typographer': True, # required for smartquotes
            },
            renderer_cls=lambda parser: self.__renderer__(self._manpage_urls, parser)
        )
        self._md.use(
            container_plugin,
            name="admonition",
            validate=lambda name, *args: (
                name.strip() in self._md.renderer._admonitions # type: ignore[attr-defined]
            )
        )
        self._md.use(deflist_plugin)
        self._md.use(myst_role_plugin)
        self._md.use(_inline_anchor_plugin)
        self._md.use(_inline_comment_plugin)
        self._md.use(_block_comment_plugin)
        self._md.enable(["smartquotes", "replacements"])

    def _post_parse(self, tokens: list[Token]) -> list[Token]:
        for i in range(0, len(tokens)):
            # parse header IDs. this is purposely simple and doesn't support
            # classes or other inds of attributes.
            if tokens[i].type == 'heading_open':
                children = tokens[i + 1].children
                assert children is not None
                if len(children) == 0 or children[-1].type != 'text':
                    continue
                if m := _HEADER_ID_RE.search(children[-1].content):
                    tokens[i].attrs['id'] = m[1]
                    children[-1].content = children[-1].content[:-len(m[0])].rstrip()

        # markdown-it signifies wide lists by setting the wrapper paragraphs
        # of each item to hidden. this is not useful for our stylesheets, which
        # signify this with a special css class on list elements instead.
        wide_stack = []
        for i in range(0, len(tokens)):
            if tokens[i].type in [ 'bullet_list_open', 'ordered_list_open' ]:
                wide_stack.append([i, True])
            elif tokens[i].type in [ 'bullet_list_close', 'ordered_list_close' ]:
                (idx, compact) = wide_stack.pop()
                tokens[idx].attrs['compact'] = compact
            elif len(wide_stack) > 0 and tokens[i].type == 'paragraph_open' and not tokens[i].hidden:
                wide_stack[-1][1] = False

        return tokens

    def _parse(self, src: str, env: Optional[MutableMapping[str, Any]] = None) -> list[Token]:
        tokens = self._md.parse(src, env if env is not None else {})
        return self._post_parse(tokens)

    def _render(self, src: str) -> str:
        env: dict[str, Any] = {}
        tokens = self._parse(src, env)
        return self._md.renderer.render(tokens, self._md.options, env) # type: ignore[no-any-return]
