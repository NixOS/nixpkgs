import nixos_render_docs as nrd

from markdown_it.token import Token

class Converter(nrd.md.Converter[nrd.docbook.DocBookRenderer]):
    # actual renderer doesn't matter, we're just parsing.
    def __init__(self, manpage_urls: dict[str, str]) -> None:
        super().__init__()
        self._renderer = nrd.docbook.DocBookRenderer(manpage_urls)

def test_heading_id_absent() -> None:
    c = Converter({})
    assert c._parse("# foo") == [
        Token(type='heading_open', tag='h1', nesting=1, attrs={}, map=[0, 1], level=0, children=None,
              content='', markup='#', info='', meta={}, block=True, hidden=False),
        Token(type='inline', tag='', nesting=0, attrs={}, map=[0, 1], level=1,
              children=[
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=0, children=None,
                        content='foo', markup='', info='', meta={}, block=False, hidden=False)
              ],
              content='foo', markup='', info='', meta={}, block=True, hidden=False),
        Token(type='heading_close', tag='h1', nesting=-1, attrs={}, map=None, level=0, children=None,
              content='', markup='#', info='', meta={}, block=True, hidden=False)
    ]

def test_heading_id_present() -> None:
    c = Converter({})
    assert c._parse("# foo {#foo}\n## bar { #bar}\n### bal { #bal}  ") == [
        Token(type='heading_open', tag='h1', nesting=1, attrs={'id': 'foo'}, map=[0, 1], level=0,
              children=None, content='', markup='#', info='', meta={}, block=True, hidden=False),
        Token(type='inline', tag='', nesting=0, attrs={}, map=[0, 1], level=1,
              content='foo {#foo}', markup='', info='', meta={}, block=True, hidden=False,
              children=[
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=0, children=None,
                        content='foo', markup='', info='', meta={}, block=False, hidden=False)
              ]),
        Token(type='heading_close', tag='h1', nesting=-1, attrs={}, map=None, level=0, children=None,
              content='', markup='#', info='', meta={}, block=True, hidden=False),
        Token(type='heading_open', tag='h2', nesting=1, attrs={'id': 'bar'}, map=[1, 2], level=0,
              children=None, content='', markup='##', info='', meta={}, block=True, hidden=False),
        Token(type='inline', tag='', nesting=0, attrs={}, map=[1, 2], level=1,
              content='bar { #bar}', markup='', info='', meta={}, block=True, hidden=False,
              children=[
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=0, children=None,
                        content='bar', markup='', info='', meta={}, block=False, hidden=False)
              ]),
        Token(type='heading_close', tag='h2', nesting=-1, attrs={}, map=None, level=0, children=None,
              content='', markup='##', info='', meta={}, block=True, hidden=False),
        Token(type='heading_open', tag='h3', nesting=1, attrs={'id': 'bal'}, map=[2, 3], level=0,
              children=None, content='', markup='###', info='', meta={}, block=True, hidden=False),
        Token(type='inline', tag='', nesting=0, attrs={}, map=[2, 3], level=1,
              content='bal { #bal}', markup='', info='', meta={}, block=True, hidden=False,
              children=[
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=0, children=None,
                        content='bal', markup='', info='', meta={}, block=False, hidden=False)
              ]),
        Token(type='heading_close', tag='h3', nesting=-1, attrs={}, map=None, level=0, children=None,
              content='', markup='###', info='', meta={}, block=True, hidden=False)
    ]

def test_heading_id_incomplete() -> None:
    c = Converter({})
    assert c._parse("# foo {#}") == [
        Token(type='heading_open', tag='h1', nesting=1, attrs={}, map=[0, 1], level=0, children=None,
              content='', markup='#', info='', meta={}, block=True, hidden=False),
        Token(type='inline', tag='', nesting=0, attrs={}, map=[0, 1], level=1,
              content='foo {#}', markup='', info='', meta={}, block=True, hidden=False,
              children=[
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=0, children=None,
                        content='foo {#}', markup='', info='', meta={}, block=False, hidden=False)
              ]),
        Token(type='heading_close', tag='h1', nesting=-1, attrs={}, map=None, level=0, children=None,
              content='', markup='#', info='', meta={}, block=True, hidden=False)
    ]

def test_heading_id_double() -> None:
    c = Converter({})
    assert c._parse("# foo {#a} {#b}") == [
        Token(type='heading_open', tag='h1', nesting=1, attrs={'id': 'b'}, map=[0, 1], level=0,
              children=None, content='', markup='#', info='', meta={}, block=True, hidden=False),
        Token(type='inline', tag='', nesting=0, attrs={}, map=[0, 1], level=1,
              content='foo {#a} {#b}', markup='', info='', meta={}, block=True, hidden=False,
              children=[
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=0, children=None,
                        content='foo {#a}', markup='', info='', meta={}, block=False, hidden=False)
              ]),
        Token(type='heading_close', tag='h1', nesting=-1, attrs={}, map=None, level=0, children=None,
              content='', markup='#', info='', meta={}, block=True, hidden=False)
    ]

def test_heading_id_suffixed() -> None:
    c = Converter({})
    assert c._parse("# foo {#a} s") == [
        Token(type='heading_open', tag='h1', nesting=1, attrs={}, map=[0, 1], level=0,
              children=None, content='', markup='#', info='', meta={}, block=True, hidden=False),
        Token(type='inline', tag='', nesting=0, attrs={}, map=[0, 1], level=1,
              content='foo {#a} s', markup='', info='', meta={}, block=True, hidden=False,
              children=[
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=0, children=None,
                        content='foo {#a} s', markup='', info='', meta={}, block=False, hidden=False)
              ]),
        Token(type='heading_close', tag='h1', nesting=-1, attrs={}, map=None, level=0, children=None,
              content='', markup='#', info='', meta={}, block=True, hidden=False)
    ]
