import nixos_render_docs

from markdown_it.token import Token

class Converter(nixos_render_docs.md.Converter):
    # actual renderer doesn't matter, we're just parsing.
    __renderer__ = nixos_render_docs.docbook.DocBookRenderer

def test_inline_anchor_simple() -> None:
    c = Converter({})
    assert c._parse("[]{#test}") == [
        Token(type='paragraph_open', tag='p', nesting=1, attrs={}, map=[0, 1], level=0, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=False),
        Token(type='inline', tag='', nesting=0, attrs={}, map=[0, 1], level=1, content='[]{#test}',
              markup='', info='', meta={}, block=True, hidden=False,
              children=[
                  Token(type='inline_anchor', tag='', nesting=0, attrs={'id': 'test'}, map=None, level=0,
                        children=None, content='', markup='', info='', meta={}, block=False, hidden=False)
              ]),
        Token(type='paragraph_close', tag='p', nesting=-1, attrs={}, map=None, level=0,
              children=None, content='', markup='', info='', meta={}, block=True, hidden=False)
    ]

def test_inline_anchor_formatted() -> None:
    c = Converter({})
    assert c._parse("a[b c `d` ***e***]{#test}f") == [
        Token(type='paragraph_open', tag='p', nesting=1, attrs={}, map=[0, 1], level=0,
              children=None, content='', markup='', info='', meta={}, block=True, hidden=False),
        Token(type='inline', tag='', nesting=0, attrs={}, map=[0, 1], level=1,
              content='a[b c `d` ***e***]{#test}f', markup='', info='', meta={}, block=True, hidden=False,
              children=[
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=0,
                        children=None, content='a', markup='', info='', meta={}, block=False, hidden=False),
                  Token(type='inline_anchor', tag='', nesting=0, attrs={'id': 'test'}, map=None, level=0,
                        children=None, content='', markup='', info='', meta={}, block=False, hidden=False),
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=0, children=None,
                        content='b c ', markup='', info='', meta={}, block=False, hidden=False),
                  Token(type='code_inline', tag='code', nesting=0, attrs={}, map=None, level=0,
                        children=None, content='d', markup='`', info='', meta={}, block=False, hidden=False),
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=0, children=None,
                        content=' ', markup='', info='', meta={}, block=False, hidden=False),
                  Token(type='em_open', tag='em', nesting=1, attrs={}, map=None, level=0, children=None,
                        content='', markup='*', info='', meta={}, block=False, hidden=False),
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=1, children=None,
                        content='', markup='', info='', meta={}, block=False, hidden=False),
                  Token(type='strong_open', tag='strong', nesting=1, attrs={}, map=None, level=1,
                        children=None, content='', markup='**', info='', meta={}, block=False, hidden=False),
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=2, children=None,
                        content='e', markup='', info='', meta={}, block=False, hidden=False),
                  Token(type='strong_close', tag='strong', nesting=-1, attrs={}, map=None, level=1,
                        children=None, content='', markup='**', info='', meta={}, block=False, hidden=False),
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=1, children=None,
                        content='', markup='', info='', meta={}, block=False, hidden=False),
                  Token(type='em_close', tag='em', nesting=-1, attrs={}, map=None, level=0, children=None,
                        content='', markup='*', info='', meta={}, block=False, hidden=False),
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=0, children=None,
                        content='f', markup='', info='', meta={}, block=False, hidden=False)
              ]),
        Token(type='paragraph_close', tag='p', nesting=-1, attrs={}, map=None, level=0, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=False)
    ]

def test_inline_anchor_in_heading() -> None:
    c = Converter({})
    # inline anchors in headers are allowed, but header attributes should be preferred
    assert c._parse("# foo []{#bar} baz") == [
        Token(type='heading_open', tag='h1', nesting=1, attrs={}, map=[0, 1], level=0, children=None,
              content='', markup='#', info='', meta={}, block=True, hidden=False),
        Token(type='inline', tag='', nesting=0, attrs={}, map=[0, 1], level=1,
              content='foo []{#bar} baz', markup='', info='', meta={}, block=True, hidden=False,
              children=[
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=0, children=None,
                        content='foo ', markup='', info='', meta={}, block=False, hidden=False),
                  Token(type='inline_anchor', tag='', nesting=0, attrs={'id': 'bar'}, map=None, level=0,
                        children=None, content='', markup='', info='', meta={}, block=False, hidden=False),
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=0, children=None,
                        content=' baz', markup='', info='', meta={}, block=False, hidden=False)
              ]),
        Token(type='heading_close', tag='h1', nesting=-1, attrs={}, map=None, level=0, children=None,
              content='', markup='#', info='', meta={}, block=True, hidden=False)
    ]

def test_inline_anchor_on_links() -> None:
    c = Converter({})
    assert c._parse("[ [a](#bar) ]{#foo}") == [
        Token(type='paragraph_open', tag='p', nesting=1, attrs={}, map=[0, 1], level=0, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=False),
        Token(type='inline', tag='', nesting=0, attrs={}, map=[0, 1], level=1, content='[ [a](#bar) ]{#foo}',
              markup='', info='', meta={}, block=True, hidden=False,
              children=[
                  Token(type='inline_anchor', tag='', nesting=0, attrs={'id': 'foo'}, map=None, level=0,
                        children=None, content='', markup='', info='', meta={}, block=False, hidden=False),
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=0, children=None,
                        content=' ', markup='', info='', meta={}, block=False, hidden=False),
                  Token(type='link_open', tag='a', nesting=1, attrs={'href': '#bar'}, map=None, level=0,
                        children=None, content='', markup='', info='', meta={}, block=False, hidden=False),
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=1, children=None,
                        content='a', markup='', info='', meta={}, block=False, hidden=False),
                  Token(type='link_close', tag='a', nesting=-1, attrs={}, map=None, level=0, children=None,
                        content='', markup='', info='', meta={}, block=False, hidden=False),
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=0, children=None,
                        content=' ', markup='', info='', meta={}, block=False, hidden=False)
              ]),
        Token(type='paragraph_close', tag='p', nesting=-1, attrs={}, map=None, level=0, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=False)
    ]

def test_inline_anchor_nested() -> None:
    # inline anchors may contain more anchors (even though this is a bit pointless)
    c = Converter({})
    assert c._parse("[ [a]{#bar} ]{#foo}") == [
        Token(type='paragraph_open', tag='p', nesting=1, attrs={}, map=[0, 1], level=0, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=False),
        Token(type='inline', tag='', nesting=0, attrs={}, map=[0, 1], level=1,
              content='[ [a]{#bar} ]{#foo}', markup='', info='', meta={}, block=True, hidden=False,
              children=[
                  Token(type='inline_anchor', tag='', nesting=0, attrs={'id': 'foo'}, map=None, level=0,
                        children=None, content='', markup='', info='', meta={}, block=False, hidden=False),
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=0, children=None,
                        content=' ', markup='', info='', meta={}, block=False, hidden=False),
                  Token(type='inline_anchor', tag='', nesting=0, attrs={'id': 'bar'}, map=None, level=0,
                        children=None, content='', markup='', info='', meta={}, block=False, hidden=False),
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=0, children=None,
                        content='a ', markup='', info='', meta={}, block=False, hidden=False)
              ]),
        Token(type='paragraph_close', tag='p', nesting=-1, attrs={}, map=None, level=0, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=False)
    ]

def test_inline_anchor_escaping() -> None:
    c = Converter({})
    assert c._parse("\\[a]{#bar}") == [
        Token(type='paragraph_open', tag='p', nesting=1, attrs={}, map=[0, 1], level=0, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=False),
        Token(type='inline', tag='', nesting=0, attrs={}, map=[0, 1], level=1,
              content='\\[a]{#bar}', markup='', info='', meta={}, block=True, hidden=False,
              children=[
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=0, children=None,
                        content='[a]{#bar}', markup='', info='', meta={}, block=False, hidden=False)
              ]),
        Token(type='paragraph_close', tag='p', nesting=-1, attrs={}, map=None, level=0, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=False)
    ]
    assert c._parse("\\\\[a]{#bar}") == [
        Token(type='paragraph_open', tag='p', nesting=1, attrs={}, map=[0, 1], level=0, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=False),
        Token(type='inline', tag='', nesting=0, attrs={}, map=[0, 1], level=1,
              content='\\\\[a]{#bar}', markup='', info='', meta={}, block=True, hidden=False,
              children=[
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=0, children=None,
                        content='\\', markup='', info='', meta={}, block=False, hidden=False),
                  Token(type='inline_anchor', tag='', nesting=0, attrs={'id': 'bar'}, map=None, level=0,
                        children=None, content='', markup='', info='', meta={}, block=False, hidden=False),
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=0, children=None,
                        content='a', markup='', info='', meta={}, block=False, hidden=False)
              ]),
        Token(type='paragraph_close', tag='p', nesting=-1, attrs={}, map=None, level=0, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=False)
    ]
    assert c._parse("\\\\\\[a]{#bar}") == [
        Token(type='paragraph_open', tag='p', nesting=1, attrs={}, map=[0, 1], level=0, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=False),
        Token(type='inline', tag='', nesting=0, attrs={}, map=[0, 1], level=1,
              children=[
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=0, children=None,
                        content='\\[a]{#bar}', markup='', info='', meta={}, block=False, hidden=False)
              ],
              content='\\\\\\[a]{#bar}', markup='', info='', meta={}, block=True, hidden=False),
        Token(type='paragraph_close', tag='p', nesting=-1, attrs={}, map=None, level=0, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=False)
    ]

def test_inline_comment_basic() -> None:
    c = Converter({})
    assert c._parse("a <!-- foo --><!----> b") == [
        Token(type='paragraph_open', tag='p', nesting=1, attrs={}, map=[0, 1], level=0, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=False),
        Token(type='inline', tag='', nesting=0, attrs={}, map=[0, 1], level=1,
              content='a <!-- foo --><!----> b', markup='', info='', meta={}, block=True, hidden=False,
              children=[
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=0, children=None,
                        content='a  b', markup='', info='', meta={}, block=False, hidden=False)
              ]),
        Token(type='paragraph_close', tag='p', nesting=-1, attrs={}, map=None, level=0, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=False)
    ]
    assert c._parse("a<!-- b -->") == [
        Token(type='paragraph_open', tag='p', nesting=1, attrs={}, map=[0, 1], level=0, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=False),
        Token(type='inline', tag='', nesting=0, attrs={}, map=[0, 1], level=1,
              content='a<!-- b -->', markup='', info='', meta={}, block=True, hidden=False,
              children=[
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=0, children=None,
                        content='a', markup='', info='', meta={}, block=False, hidden=False)
              ]),
        Token(type='paragraph_close', tag='p', nesting=-1, attrs={}, map=None, level=0, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=False)
    ]

def test_inline_comment_does_not_nest_in_code() -> None:
    c = Converter({})
    assert c._parse("`a<!-- b -->c`") == [
        Token(type='paragraph_open', tag='p', nesting=1, attrs={}, map=[0, 1], level=0, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=False),
        Token(type='inline', tag='', nesting=0, attrs={}, map=[0, 1], level=1,
              content='`a<!-- b -->c`', markup='', info='', meta={}, block=True, hidden=False,
              children=[
                  Token(type='code_inline', tag='code', nesting=0, attrs={}, map=None, level=0, children=None,
                        content='a<!-- b -->c', markup='`', info='', meta={}, block=False, hidden=False)
              ]),
        Token(type='paragraph_close', tag='p', nesting=-1, attrs={}, map=None, level=0, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=False)
    ]

def test_inline_comment_does_not_nest_elsewhere() -> None:
    c = Converter({})
    assert c._parse("*a<!-- b -->c*") == [
        Token(type='paragraph_open', tag='p', nesting=1, attrs={}, map=[0, 1], level=0, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=False),
        Token(type='inline', tag='', nesting=0, attrs={}, map=[0, 1], level=1,
              content='*a<!-- b -->c*', markup='', info='', meta={}, block=True, hidden=False,
              children=[
                  Token(type='em_open', tag='em', nesting=1, attrs={}, map=None, level=0, children=None,
                        content='', markup='*', info='', meta={}, block=False, hidden=False),
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=1, children=None,
                        content='ac', markup='', info='', meta={}, block=False, hidden=False),
                  Token(type='em_close', tag='em', nesting=-1, attrs={}, map=None, level=0, children=None,
                        content='', markup='*', info='', meta={}, block=False, hidden=False)
              ]),
        Token(type='paragraph_close', tag='p', nesting=-1, attrs={}, map=None, level=0, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=False)
    ]

def test_inline_comment_can_be_escaped() -> None:
    c = Converter({})
    assert c._parse("a\\<!-- b -->c") == [
        Token(type='paragraph_open', tag='p', nesting=1, attrs={}, map=[0, 1], level=0, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=False),
        Token(type='inline', tag='', nesting=0, attrs={}, map=[0, 1], level=1,
              content='a\\<!-- b -->c', markup='', info='', meta={}, block=True, hidden=False,
              children=[
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=0, children=None,
                        content='a<!-- b -->c', markup='', info='', meta={}, block=False, hidden=False)
              ]),
        Token(type='paragraph_close', tag='p', nesting=-1, attrs={}, map=None, level=0, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=False)
    ]
    assert c._parse("a\\\\<!-- b -->c") == [
        Token(type='paragraph_open', tag='p', nesting=1, attrs={}, map=[0, 1], level=0, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=False),
        Token(type='inline', tag='', nesting=0, attrs={}, map=[0, 1], level=1,
              children=[
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=0, children=None,
                        content='a\\c', markup='', info='', meta={}, block=False, hidden=False)
              ],
              content='a\\\\<!-- b -->c', markup='', info='', meta={}, block=True, hidden=False),
        Token(type='paragraph_close', tag='p', nesting=-1, attrs={}, map=None, level=0, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=False)
    ]
    assert c._parse("a\\\\\\<!-- b -->c") == [
        Token(type='paragraph_open', tag='p', nesting=1, attrs={}, map=[0, 1], level=0, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=False),
        Token(type='inline', tag='', nesting=0, attrs={}, map=[0, 1], level=1,
              children=[
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=0, children=None,
                        content='a\\<!-- b -->c', markup='', info='', meta={}, block=False, hidden=False)
              ],
              content='a\\\\\\<!-- b -->c', markup='', info='', meta={}, block=True, hidden=False),
        Token(type='paragraph_close', tag='p', nesting=-1, attrs={}, map=None, level=0, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=False)
    ]

def test_block_comment() -> None:
    c = Converter({})
    assert c._parse("<!-- a -->") == []
    assert c._parse("<!-- a\n-->") == []
    assert c._parse("<!--\na\n-->") == []
    assert c._parse("<!--\n\na\n\n-->") == []
    assert c._parse("<!--\n\n```\n\n\n```\n\n-->") == []
