from typing import Literal, Sequence

from markdown_it.token import Token

# FragmentType is used to restrict structural include blocks.
FragmentType = Literal['preface', 'part', 'chapter', 'section', 'appendix']

# in the TOC all fragments are allowed, plus the all-encompassing book.
TocEntryType = Literal['book', 'preface', 'part', 'chapter', 'section', 'appendix']

def check_titles(kind: TocEntryType, tokens: Sequence[Token]) -> None:
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
