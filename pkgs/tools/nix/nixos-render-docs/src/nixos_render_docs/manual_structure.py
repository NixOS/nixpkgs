from typing import Literal, Sequence

from markdown_it.token import Token

# FragmentType is used to restrict structural include blocks.
FragmentType = Literal['preface', 'part', 'chapter', 'section', 'appendix']

# in the TOC all fragments are allowed, plus the all-encompassing book.
TocEntryType = Literal['book', 'preface', 'part', 'chapter', 'section', 'appendix']

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
# this is a limitation of the current renderers that do not handle this case well
# even though it is supported in docbook (and probably supportable anywhere else).
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
