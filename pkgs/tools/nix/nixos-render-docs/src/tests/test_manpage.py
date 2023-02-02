import nixos_render_docs

from typing import Mapping, Optional

import markdown_it

class Converter(nixos_render_docs.md.Converter):
    def __renderer__(self, manpage_urls: Mapping[str, str],
                     parser: Optional[markdown_it.MarkdownIt] = None
                     ) -> nixos_render_docs.manpage.ManpageRenderer:
        return nixos_render_docs.manpage.ManpageRenderer(manpage_urls, self.options_by_id, parser)

    def __init__(self, manpage_urls: Mapping[str, str], options_by_id: dict[str, str] = {}):
        self.options_by_id = options_by_id
        super().__init__(manpage_urls)

def test_inline_code() -> None:
    c = Converter({})
    assert c._render("1  `x  a  x`  2") == "1 \\fR\\(oqx  a  x\\(cq\\fP 2"

def test_fonts() -> None:
    c = Converter({})
    assert c._render("*a **b** c*") == "\\fIa \\fBb\\fI c\\fR"
    assert c._render("*a [1 `2`](3) c*") == "\\fIa \\fB1 \\fR\\(oq2\\(cq\\fP\\fI c\\fR"

def test_expand_link_targets() -> None:
    c = Converter({}, { '#foo1': "bar", "#foo2": "bar" })
    assert (c._render("[a](#foo1) [](#foo2) [b](#bar1) [](#bar2)") ==
            "\\fBa\\fR \\fBbar\\fR \\fBb\\fR \\fB\\fR")

def test_collect_links() -> None:
    c = Converter({}, { '#foo': "bar" })
    assert isinstance(c._md.renderer, nixos_render_docs.manpage.ManpageRenderer)
    c._md.renderer.link_footnotes = []
    assert c._render("[a](link1) [b](link2)") == "\\fBa\\fR[1]\\fR \\fBb\\fR[2]\\fR"
    assert c._md.renderer.link_footnotes == ['link1', 'link2']

def test_dedup_links() -> None:
    c = Converter({}, { '#foo': "bar" })
    assert isinstance(c._md.renderer, nixos_render_docs.manpage.ManpageRenderer)
    c._md.renderer.link_footnotes = []
    assert c._render("[a](link) [b](link)") == "\\fBa\\fR[1]\\fR \\fBb\\fR[1]\\fR"
    assert c._md.renderer.link_footnotes == ['link']
