from pathlib import Path

from markdown_it.token import Token
from nixos_render_docs.manual import HTMLConverter, HTMLParameters
from nixos_render_docs.md import Converter

auto_id_prefix="TEST_PREFIX"
def set_prefix(token: Token, ident: str) -> None:
    token.attrs["id"] = f"{auto_id_prefix}-{ident}"


def test_auto_id_prefix_simple() -> None:
    md = HTMLConverter("1.0.0", HTMLParameters("", [], [], 2, 2, 2, Path("")), {})

    src = f"""
# title

## subtitle
    """
    tokens = Converter()._parse(src)
    md._handle_headings(tokens, on_heading=set_prefix)

    assert [
        {**token.attrs, "tag": token.tag}
        for token in tokens
        if token.type == "heading_open"
    ] == [
        {"id": "TEST_PREFIX-1", "tag": "h1"},
        {"id": "TEST_PREFIX-1.1", "tag": "h2"}
    ]


def test_auto_id_prefix_repeated() -> None:
    md = HTMLConverter("1.0.0", HTMLParameters("", [], [], 2, 2, 2, Path("")), {})

    src = f"""
# title

## subtitle

# title2

## subtitle2
    """
    tokens = Converter()._parse(src)
    md._handle_headings(tokens, on_heading=set_prefix)

    assert [
        {**token.attrs, "tag": token.tag}
        for token in tokens
        if token.type == "heading_open"
    ] == [
        {"id": "TEST_PREFIX-1", "tag": "h1"},
        {"id": "TEST_PREFIX-1.1", "tag": "h2"},
        {"id": "TEST_PREFIX-2", "tag": "h1"},
        {"id": "TEST_PREFIX-2.1", "tag": "h2"},
    ]

def test_auto_id_prefix_maximum_nested() -> None:
    md = HTMLConverter("1.0.0", HTMLParameters("", [], [], 2, 2, 2, Path("")), {})

    src = f"""
# h1

## h2

### h3

#### h4

##### h5

###### h6

## h2.2
    """
    tokens = Converter()._parse(src)
    md._handle_headings(tokens, on_heading=set_prefix)

    assert [
        {**token.attrs, "tag": token.tag}
        for token in tokens
        if token.type == "heading_open"
    ] == [
        {"id": "TEST_PREFIX-1", "tag": "h1"},
        {"id": "TEST_PREFIX-1.1", "tag": "h2"},
        {"id": "TEST_PREFIX-1.1.1", "tag": "h3"},
        {"id": "TEST_PREFIX-1.1.1.1", "tag": "h4"},
        {"id": "TEST_PREFIX-1.1.1.1.1", "tag": "h5"},
        {"id": "TEST_PREFIX-1.1.1.1.1.1", "tag": "h6"},
        {"id": "TEST_PREFIX-1.2", "tag": "h2"},
    ]
