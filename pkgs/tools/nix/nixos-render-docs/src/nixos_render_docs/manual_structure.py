from __future__ import annotations

import dataclasses as dc
import html
import itertools

from typing import cast, get_args, Iterable, Literal, Sequence

from markdown_it.token import Token

from .utils import Freezeable

# FragmentType is used to restrict structural include blocks.
FragmentType = Literal['preface', 'part', 'chapter', 'section', 'appendix']

# in the TOC all fragments are allowed, plus the all-encompassing book.
TocEntryType = Literal['book', 'preface', 'part', 'chapter', 'section', 'appendix', 'example', 'figure']

def is_include(token: Token) -> bool:
    return token.type == "fence" and token.info.startswith("{=include=} ")

# toplevel file must contain only the title headings and includes, anything else
# would cause strange rendering.
def _check_book_structure(tokens: Sequence[Token]) -> None:
    for token in tokens[6:]:
        if not is_include(token):
            assert token.map
            raise RuntimeError(f"unexpected content in line {token.map[0] + 1}, "
                               "expected structural include")

# much like books, parts may not contain headings other than their title heading.
# this is a limitation of the current renderers and TOC generators that do not handle
# this case well even though it is supported in docbook (and probably supportable
# anywhere else).
def _check_part_structure(tokens: Sequence[Token]) -> None:
    _check_fragment_structure(tokens)
    for token in tokens[3:]:
        if token.type == 'heading_open':
            assert token.map
            raise RuntimeError(f"unexpected heading in line {token.map[0] + 1}")

# two include blocks must either be adjacent or separated by a heading, otherwise
# we cannot generate a correct TOC (since there'd be nothing to link to between
# the two includes).
def _check_fragment_structure(tokens: Sequence[Token]) -> None:
    for i, token in enumerate(tokens):
        if is_include(token) \
           and i + 1 < len(tokens) \
           and not (is_include(tokens[i + 1]) or tokens[i + 1].type == 'heading_open'):
            assert token.map
            raise RuntimeError(f"unexpected content in line {token.map[0] + 1}, "
                               "expected heading or structural include")

def check_structure(kind: TocEntryType, tokens: Sequence[Token]) -> None:
    wanted = { 'h1': 'title' }
    wanted |= { 'h2': 'subtitle' } if kind == 'book' else {}
    for (i, (tag, role)) in enumerate(wanted.items()):
        if len(tokens) < 3 * (i + 1):
            raise RuntimeError(f"missing {role} ({tag}) heading")
        token = tokens[3 * i]
        if token.type != 'heading_open' or token.tag != tag:
            assert token.map
            raise RuntimeError(f"expected {role} ({tag}) heading in line {token.map[0] + 1}", token)
    for t in tokens[3 * len(wanted):]:
        if t.type != 'heading_open' or not (role := wanted.get(t.tag, '')):
            continue
        assert t.map
        raise RuntimeError(
            f"only one {role} heading ({t.markup} [text...]) allowed per "
            f"{kind}, but found a second in line {t.map[0] + 1}. "
            "please remove all such headings except the first or demote the subsequent headings.",
            t)

    last_heading_level = 0
    for token in tokens:
        if token.type != 'heading_open':
            continue

        # book subtitle headings do not need an id, only book title headings do.
        # every other headings needs one too. we need this to build a TOC and to
        # provide stable links if the manual changes shape.
        if 'id' not in token.attrs and (kind != 'book' or token.tag != 'h2'):
            assert token.map
            raise RuntimeError(f"heading in line {token.map[0] + 1} does not have an id")

        level = int(token.tag[1:]) # because tag = h1..h6
        if level > last_heading_level + 1:
            assert token.map
            raise RuntimeError(f"heading in line {token.map[0] + 1} skips one or more heading levels, "
                               "which is currently not allowed")
        last_heading_level = level

    if kind == 'book':
        _check_book_structure(tokens)
    elif kind == 'part':
        _check_part_structure(tokens)
    else:
        _check_fragment_structure(tokens)

@dc.dataclass(frozen=True)
class XrefTarget:
    id: str
    """link label for `[](#local-references)`"""
    title_html: str
    """toc label"""
    toc_html: str | None
    """text for `<title>` tags and `title="..."` attributes"""
    title: str | None
    """path to file that contains the anchor"""
    path: str
    """whether to drop the `#anchor` from links when expanding xrefs"""
    drop_fragment: bool = False
    """whether to drop the `path.html` from links when expanding xrefs.
       mostly useful for docbook compatibility"""
    drop_target: bool = False

    def href(self) -> str:
        path = "" if self.drop_target else html.escape(self.path, True)
        return path if self.drop_fragment else f"{path}#{html.escape(self.id, True)}"

@dc.dataclass
class TocEntry(Freezeable):
    kind: TocEntryType
    target: XrefTarget
    parent: TocEntry | None = None
    prev: TocEntry | None = None
    next: TocEntry | None = None
    children: list[TocEntry] = dc.field(default_factory=list)
    starts_new_chunk: bool = False
    examples: list[TocEntry] = dc.field(default_factory=list)
    figures: list[TocEntry] = dc.field(default_factory=list)

    @property
    def root(self) -> TocEntry:
        return self.parent.root if self.parent else self

    @classmethod
    def of(cls, token: Token) -> TocEntry:
        entry = token.meta.get('TocEntry')
        if not isinstance(entry, TocEntry):
            raise RuntimeError('requested toc entry, none found', token)
        return entry

    @classmethod
    def collect_and_link(cls, xrefs: dict[str, XrefTarget], tokens: Sequence[Token]) -> TocEntry:
        entries, examples, figures = cls._collect_entries(xrefs, tokens, 'book')

        def flatten_with_parent(this: TocEntry, parent: TocEntry | None) -> Iterable[TocEntry]:
            this.parent = parent
            return itertools.chain([this], *[ flatten_with_parent(c, this) for c in this.children ])

        flat = list(flatten_with_parent(entries, None))
        prev = flat[0]
        prev.starts_new_chunk = True
        paths_seen = set([prev.target.path])
        for c in flat[1:]:
            if prev.target.path != c.target.path and c.target.path not in paths_seen:
                c.starts_new_chunk = True
                c.prev, prev.next = prev, c
                prev = c
            paths_seen.add(c.target.path)

        flat[0].examples = examples
        flat[0].figures = figures

        for c in flat:
            c.freeze()

        return entries

    @classmethod
    def _collect_entries(cls, xrefs: dict[str, XrefTarget], tokens: Sequence[Token],
                         kind: TocEntryType) -> tuple[TocEntry, list[TocEntry], list[TocEntry]]:
        # we assume that check_structure has been run recursively over the entire input.
        # list contains (tag, entry) pairs that will collapse to a single entry for
        # the full sequence.
        entries: list[tuple[str, TocEntry]] = []
        examples: list[TocEntry] = []
        figures: list[TocEntry] = []
        for token in tokens:
            if token.type.startswith('included_') and (included := token.meta.get('included')):
                fragment_type_str = token.type[9:].removesuffix('s')
                assert fragment_type_str in get_args(TocEntryType)
                fragment_type = cast(TocEntryType, fragment_type_str)
                for fragment, _path in included:
                    subentries, subexamples, subfigures = cls._collect_entries(xrefs, fragment, fragment_type)
                    entries[-1][1].children.append(subentries)
                    examples += subexamples
                    figures += subfigures
            elif token.type == 'heading_open' and (id := cast(str, token.attrs.get('id', ''))):
                while len(entries) > 1 and entries[-1][0] >= token.tag:
                    entries[-2][1].children.append(entries.pop()[1])
                entries.append((token.tag,
                                TocEntry(kind if token.tag == 'h1' else 'section', xrefs[id])))
                token.meta['TocEntry'] = entries[-1][1]
            elif token.type == 'example_open' and (id := cast(str, token.attrs.get('id', ''))):
                examples.append(TocEntry('example', xrefs[id]))
            elif token.type == 'figure_open' and (id := cast(str, token.attrs.get('id', ''))):
                figures.append(TocEntry('figure', xrefs[id]))

        while len(entries) > 1:
            entries[-2][1].children.append(entries.pop()[1])
        return (entries[0][1], examples, figures)
