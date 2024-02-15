import nixos_render_docs as nrd

from sample_md import sample1

from typing import Mapping


class Converter(nrd.md.Converter[nrd.manpage.ManpageRenderer]):
    def __init__(self, manpage_urls: Mapping[str, str], options_by_id: dict[str, str] = {}):
        super().__init__()
        self._renderer = nrd.manpage.ManpageRenderer(manpage_urls, options_by_id)

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
    c._renderer.link_footnotes = []
    assert c._render("[a](link1) [b](link2)") == "\\fBa\\fR[1]\\fR \\fBb\\fR[2]\\fR"
    assert c._renderer.link_footnotes == ['link1', 'link2']

def test_dedup_links() -> None:
    c = Converter({}, { '#foo': "bar" })
    c._renderer.link_footnotes = []
    assert c._render("[a](link) [b](link)") == "\\fBa\\fR[1]\\fR \\fBb\\fR[1]\\fR"
    assert c._renderer.link_footnotes == ['link']

def test_full() -> None:
    c = Converter({ 'man(1)': 'http://example.org' })
    assert c._render(sample1) == """\
.sp
.RS 4
\\fBWarning\\fP
.br
foo
.sp
.RS 4
\\fBNote\\fP
.br
nested
.RE
.RE
.sp
\\fBmultiline\\fR
.sp
\\fBman\\fP\\fR(1)\\fP reference
.sp
some nested anchors
.sp
\\fIemph\\fR \\fBstrong\\fR \\fInesting emph \\fBand strong\\fI and \\fR\\(oqcode\\(cq\\fP\\fR
.sp
.RS 4
\\h'-2'\\fB\\[u2022]\\fP\\h'1'\\c
wide bullet
.RE
.sp
.RS 4
\\h'-2'\\fB\\[u2022]\\fP\\h'1'\\c
list
.RE
.sp
.RS 4
\\h'-3'\\fB1\\&.\\fP\\h'1'\\c
wide ordered
.RE
.sp
.RS 4
\\h'-3'\\fB2\\&.\\fP\\h'1'\\c
list
.RE
.sp
.RS 4
\\h'-2'\\fB\\[u2022]\\fP\\h'1'\\c
narrow bullet
.RE
.RS 4
\\h'-2'\\fB\\[u2022]\\fP\\h'1'\\c
list
.RE
.sp
.RS 4
\\h'-3'\\fB1\\&.\\fP\\h'1'\\c
narrow ordered
.RE
.RS 4
\\h'-3'\\fB2\\&.\\fP\\h'1'\\c
list
.RE
.sp
.RS 4
\\h'-3'\\fI\\(lq\\(rq\\fP\\h'1'\\c
quotes
.sp
.RS 4
\\h'-3'\\fI\\(lq\\(rq\\fP\\h'1'\\c
with \\fInesting\\fR
.sp
.RS 4
.nf
nested code block
.fi
.RE
.RE
.sp
.RS 4
\\h'-2'\\fB\\[u2022]\\fP\\h'1'\\c
and lists
.RE
.RS 4
\\h'-2'\\fB\\[u2022]\\fP\\h'1'\\c
.sp
.RS 4
.nf
containing code
.fi
.RE
.RE
.sp
and more quote
.RE
.sp
.RS 6
\\h'-5'\\fB100\\&.\\fP\\h'1'\\c
list starting at 100
.RE
.RS 6
\\h'-5'\\fB101\\&.\\fP\\h'1'\\c
goes on
.RE
.RS 4
.PP
deflist
.RS 4
.RS 4
\\h'-3'\\fI\\(lq\\(rq\\fP\\h'1'\\c
with a quote and stuff
.RE
.sp
.RS 4
.nf
code block
.fi
.RE
.sp
.RS 4
.nf
fenced block
.fi
.RE
.sp
text
.RE
.PP
more stuff in same deflist
.RS 4
foo
.RE
.RE"""
