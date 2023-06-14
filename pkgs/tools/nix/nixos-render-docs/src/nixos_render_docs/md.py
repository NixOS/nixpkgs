from abc import ABC
from collections.abc import Mapping, MutableMapping, Sequence
from typing import Any, cast, Generic, get_args, Iterable, Literal, NoReturn, Optional, TypeVar

import dataclasses
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

def md_make_code(code: str, info: str = "", multiline: Optional[bool] = None) -> str:
    # for multi-line code blocks we only have to count ` runs at the beginning
    # of a line, but this is much easier.
    multiline = multiline or info != "" or '\n' in code
    longest, current = (0, 0)
    for c in code:
        current = current + 1 if c == '`' else 0
        longest = max(current, longest)
    # inline literals need a space to separate ticks from content, code blocks
    # need newlines. inline literals need one extra tick, code blocks need three.
    ticks, sep = ('`' * (longest + (3 if multiline else 1)), '\n' if multiline else ' ')
    return f"{ticks}{info}{sep}{code}{sep}{ticks}"

AttrBlockKind = Literal['admonition', 'example']

AdmonitionKind = Literal["note", "caution", "tip", "important", "warning"]

class Renderer:
    _admonitions: dict[AdmonitionKind, tuple[RenderFn, RenderFn]]
    _admonition_stack: list[AdmonitionKind]

    def __init__(self, manpage_urls: Mapping[str, str]):
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
            "admonition_open": self.admonition_open,
            "admonition_close": self.admonition_close,
            "attr_span_begin": self.attr_span_begin,
            "attr_span_end": self.attr_span_end,
            "heading_open": self.heading_open,
            "heading_close": self.heading_close,
            "ordered_list_open": self.ordered_list_open,
            "ordered_list_close": self.ordered_list_close,
            "example_open": self.example_open,
            "example_close": self.example_close,
            "example_title_open": self.example_title_open,
            "example_title_close": self.example_title_close,
        }

        self._admonitions = {
            "note": (self.note_open, self.note_close),
            "caution": (self.caution_open,self.caution_close),
            "tip": (self.tip_open, self.tip_close),
            "important": (self.important_open, self.important_close),
            "warning": (self.warning_open, self.warning_close),
        }
        self._admonition_stack = []

    def _join_block(self, ls: Iterable[str]) -> str:
        return "".join(ls)
    def _join_inline(self, ls: Iterable[str]) -> str:
        return "".join(ls)

    def admonition_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        tag = token.meta['kind']
        self._admonition_stack.append(tag)
        return self._admonitions[tag][0](token, tokens, i)
    def admonition_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return self._admonitions[self._admonition_stack.pop()][1](token, tokens, i)

    def render(self, tokens: Sequence[Token]) -> str:
        def do_one(i: int, token: Token) -> str:
            if token.type == "inline":
                assert token.children is not None
                return self.renderInline(token.children)
            elif token.type in self.rules:
                return self.rules[token.type](tokens[i], tokens, i)
            else:
                raise NotImplementedError("md token not supported yet", token)
        return self._join_block(map(lambda arg: do_one(*arg), enumerate(tokens)))
    def renderInline(self, tokens: Sequence[Token]) -> str:
        def do_one(i: int, token: Token) -> str:
            if token.type in self.rules:
                return self.rules[token.type](tokens[i], tokens, i)
            else:
                raise NotImplementedError("md token not supported yet", token)
        return self._join_inline(map(lambda arg: do_one(*arg), enumerate(tokens)))

    def text(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        raise RuntimeError("md token not supported", token)
    def paragraph_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        raise RuntimeError("md token not supported", token)
    def paragraph_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        raise RuntimeError("md token not supported", token)
    def hardbreak(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        raise RuntimeError("md token not supported", token)
    def softbreak(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        raise RuntimeError("md token not supported", token)
    def code_inline(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        raise RuntimeError("md token not supported", token)
    def code_block(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        raise RuntimeError("md token not supported", token)
    def link_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        raise RuntimeError("md token not supported", token)
    def link_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        raise RuntimeError("md token not supported", token)
    def list_item_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        raise RuntimeError("md token not supported", token)
    def list_item_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        raise RuntimeError("md token not supported", token)
    def bullet_list_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        raise RuntimeError("md token not supported", token)
    def bullet_list_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        raise RuntimeError("md token not supported", token)
    def em_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        raise RuntimeError("md token not supported", token)
    def em_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        raise RuntimeError("md token not supported", token)
    def strong_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        raise RuntimeError("md token not supported", token)
    def strong_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        raise RuntimeError("md token not supported", token)
    def fence(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        raise RuntimeError("md token not supported", token)
    def blockquote_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        raise RuntimeError("md token not supported", token)
    def blockquote_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        raise RuntimeError("md token not supported", token)
    def note_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        raise RuntimeError("md token not supported", token)
    def note_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        raise RuntimeError("md token not supported", token)
    def caution_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        raise RuntimeError("md token not supported", token)
    def caution_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        raise RuntimeError("md token not supported", token)
    def important_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        raise RuntimeError("md token not supported", token)
    def important_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        raise RuntimeError("md token not supported", token)
    def tip_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        raise RuntimeError("md token not supported", token)
    def tip_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        raise RuntimeError("md token not supported", token)
    def warning_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        raise RuntimeError("md token not supported", token)
    def warning_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        raise RuntimeError("md token not supported", token)
    def dl_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        raise RuntimeError("md token not supported", token)
    def dl_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        raise RuntimeError("md token not supported", token)
    def dt_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        raise RuntimeError("md token not supported", token)
    def dt_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        raise RuntimeError("md token not supported", token)
    def dd_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        raise RuntimeError("md token not supported", token)
    def dd_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        raise RuntimeError("md token not supported", token)
    def myst_role(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        raise RuntimeError("md token not supported", token)
    def attr_span_begin(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        raise RuntimeError("md token not supported", token)
    def attr_span_end(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        raise RuntimeError("md token not supported", token)
    def heading_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        raise RuntimeError("md token not supported", token)
    def heading_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        raise RuntimeError("md token not supported", token)
    def ordered_list_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        raise RuntimeError("md token not supported", token)
    def ordered_list_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        raise RuntimeError("md token not supported", token)
    def example_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        raise RuntimeError("md token not supported", token)
    def example_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        raise RuntimeError("md token not supported", token)
    def example_title_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        raise RuntimeError("md token not supported", token)
    def example_title_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        raise RuntimeError("md token not supported", token)

def _is_escaped(src: str, pos: int) -> bool:
    found = 0
    while pos >= 0 and src[pos] == '\\':
        found += 1
        pos -= 1
    return found % 2 == 1

# the contents won't be split apart in the regex because spacing rules get messy here
_ATTR_SPAN_PATTERN = re.compile(r"\{([^}]*)\}")
# this one is for blocks with attrs. we want to use it with fullmatch() to deconstruct an info.
_ATTR_BLOCK_PATTERN = re.compile(r"\s*\{([^}]*)\}\s*")

def _parse_attrs(s: str) -> Optional[tuple[Optional[str], list[str]]]:
    (id, classes) = (None, [])
    for part in s.split():
        if part.startswith('#'):
            if id is not None:
                return None # just bail on multiple ids instead of trying to recover
            id = part[1:]
        elif part.startswith('.'):
            classes.append(part[1:])
        else:
            return None # no support for key=value attrs like in pandoc

    return (id, classes)

def _parse_blockattrs(info: str) -> Optional[tuple[AttrBlockKind, Optional[str], list[str]]]:
    if (m := _ATTR_BLOCK_PATTERN.fullmatch(info)) is None:
        return None
    if (parsed_attrs := _parse_attrs(m[1])) is None:
        return None
    id, classes = parsed_attrs
    # check that we actually support this kind of block, and that is adheres to
    # whetever restrictions we want to enforce for that kind of block.
    if len(classes) == 1 and classes[0] in get_args(AdmonitionKind):
        # don't want to support ids for admonitions just yet
        if id is not None:
            return None
        return ('admonition', id, classes)
    if classes == ['example']:
        return ('example', id, classes)
    return None

def _attr_span_plugin(md: markdown_it.MarkdownIt) -> None:
    def attr_span(state: markdown_it.rules_inline.StateInline, silent: bool) -> bool:
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

        # match id and classes in any combination
        match = _ATTR_SPAN_PATTERN.match(state.src[label_end + 1 : ])
        if not match:
            return False

        if not silent:
            if (parsed_attrs := _parse_attrs(match[1])) is None:
                return False
            id, classes = parsed_attrs

            token = state.push("attr_span_begin", "span", 1) # type: ignore[no-untyped-call]
            if id:
                token.attrs['id'] = id
            if classes:
                token.attrs['class'] = " ".join(classes)

            state.pos = label_begin
            state.posMax = label_end
            state.md.inline.tokenize(state)

            state.push("attr_span_end", "span", -1) # type: ignore[no-untyped-call]

        state.pos = label_end + match.end() + 1
        state.posMax = input_end
        return True

    md.inline.ruler.before("link", "attr_span", attr_span)

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

_HEADER_ID_RE = re.compile(r"\s*\{\s*\#([\w.-]+)\s*\}\s*$")

def _heading_ids(md: markdown_it.MarkdownIt) -> None:
    def heading_ids(state: markdown_it.rules_core.StateCore) -> None:
        tokens = state.tokens
        # this is purposely simple and doesn't support classes or other kinds of attributes.
        for (i, token) in enumerate(tokens):
            if token.type == 'heading_open':
                children = tokens[i + 1].children
                assert children is not None
                if len(children) == 0 or children[-1].type != 'text':
                    continue
                if m := _HEADER_ID_RE.search(children[-1].content):
                    tokens[i].attrs['id'] = m[1]
                    children[-1].content = children[-1].content[:-len(m[0])].rstrip()

    md.core.ruler.before("replacements", "heading_ids", heading_ids)

def _compact_list_attr(md: markdown_it.MarkdownIt) -> None:
    @dataclasses.dataclass
    class Entry:
        head: Token
        end: int
        compact: bool = True

    def compact_list_attr(state: markdown_it.rules_core.StateCore) -> None:
        # markdown-it signifies wide lists by setting the wrapper paragraphs
        # of each item to hidden. this is not useful for our stylesheets, which
        # signify this with a special css class on list elements instead.
        stack = []
        for token in state.tokens:
            if token.type in [ 'bullet_list_open', 'ordered_list_open' ]:
                stack.append(Entry(token, cast(int, token.attrs.get('start', 1))))
            elif token.type in [ 'bullet_list_close', 'ordered_list_close' ]:
                lst = stack.pop()
                lst.head.meta['compact'] = lst.compact
                if token.type == 'ordered_list_close':
                    lst.head.meta['end'] = lst.end - 1
            elif len(stack) > 0 and token.type == 'paragraph_open' and not token.hidden:
                stack[-1].compact = False
            elif token.type == 'list_item_open':
                stack[-1].end += 1

    md.core.ruler.push("compact_list_attr", compact_list_attr)

def _block_attr(md: markdown_it.MarkdownIt) -> None:
    def assert_never(value: NoReturn) -> NoReturn:
        assert False

    def block_attr(state: markdown_it.rules_core.StateCore) -> None:
        stack = []
        for token in state.tokens:
            if token.type == 'container_blockattr_open':
                if (parsed_attrs := _parse_blockattrs(token.info)) is None:
                    # if we get here we've missed a possible case in the plugin validate function
                    raise RuntimeError("this should be unreachable")
                kind, id, classes = parsed_attrs
                if kind == 'admonition':
                    token.type = 'admonition_open'
                    token.meta['kind'] = classes[0]
                    stack.append('admonition_close')
                elif kind == 'example':
                    token.type = 'example_open'
                    if id is not None:
                        token.attrs['id'] = id
                    stack.append('example_close')
                else:
                    assert_never(kind)
            elif token.type == 'container_blockattr_close':
                token.type = stack.pop()

    md.core.ruler.push("block_attr", block_attr)

def _example_titles(md: markdown_it.MarkdownIt) -> None:
    """
    find title headings of examples and stick them into meta for renderers, then
    remove them from the token stream. also checks whether any example contains a
    non-title heading since those would make toc generation extremely complicated.
    """
    def example_titles(state: markdown_it.rules_core.StateCore) -> None:
        in_example = [False]
        for i, token in enumerate(state.tokens):
            if token.type == 'example_open':
                if state.tokens[i + 1].type == 'heading_open':
                    assert state.tokens[i + 3].type == 'heading_close'
                    state.tokens[i + 1].type = 'example_title_open'
                    state.tokens[i + 3].type = 'example_title_close'
                else:
                    assert token.map
                    raise RuntimeError(f"found example without title in line {token.map[0] + 1}")
                in_example.append(True)
            elif token.type == 'example_close':
                in_example.pop()
            elif token.type == 'heading_open' and in_example[-1]:
                assert token.map
                raise RuntimeError(f"unexpected non-title heading in example in line {token.map[0] + 1}")

    md.core.ruler.push("example_titles", example_titles)

TR = TypeVar('TR', bound='Renderer')

class Converter(ABC, Generic[TR]):
    # we explicitly disable markdown-it rendering support and use our own entirely.
    # rendering is well separated from parsing and our renderers carry much more state than
    # markdown-it easily acknowledges as 'good' (unless we used the untyped env args to
    # shuttle that state around, which is very fragile)
    class ForbiddenRenderer(markdown_it.renderer.RendererProtocol):
        __output__ = "none"

        def __init__(self, parser: Optional[markdown_it.MarkdownIt]):
            pass

        def render(self, tokens: Sequence[Token], options: OptionsDict,
                   env: MutableMapping[str, Any]) -> str:
            raise NotImplementedError("do not use Converter._md.renderer. 'tis a silly place")

    _renderer: TR

    def __init__(self) -> None:
        self._md = markdown_it.MarkdownIt(
            "commonmark",
            {
                'maxNesting': 100,   # default is 20
                'html': False,       # not useful since we target many formats
                'typographer': True, # required for smartquotes
            },
            renderer_cls=self.ForbiddenRenderer
        )
        self._md.use(
            container_plugin,
            name="blockattr",
            validate=lambda name, *args: _parse_blockattrs(name),
        )
        self._md.use(deflist_plugin)
        self._md.use(myst_role_plugin)
        self._md.use(_attr_span_plugin)
        self._md.use(_inline_comment_plugin)
        self._md.use(_block_comment_plugin)
        self._md.use(_heading_ids)
        self._md.use(_compact_list_attr)
        self._md.use(_block_attr)
        self._md.use(_example_titles)
        self._md.enable(["smartquotes", "replacements"])

    def _parse(self, src: str) -> list[Token]:
        return self._md.parse(src, {})

    def _render(self, src: str) -> str:
        tokens = self._parse(src)
        return self._renderer.render(tokens)
