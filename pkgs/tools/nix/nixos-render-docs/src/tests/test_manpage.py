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
    assert c._render("1  `x  a  x`  2") == "1 x  a  x 2"

def test_fonts() -> None:
    c = Converter({})
    assert c._render("*a **b** c*") == "\\fIa \\fBb\\fI c\\fR"
    assert c._render("*a [1 `2`](3) c*") == "\\fIa \\fB1 2\\fI c\\fR"

def test_expand_link_targets() -> None:
    c = Converter({}, { '#foo1': "bar", "#foo2": "bar" })
    assert (c._render("[a](#foo1) [](#foo2) [b](#bar1) [](#bar2)") ==
            "\\fRa\\fR \\fBbar\\fR \\fBb\\fR \\fB\\fR")
