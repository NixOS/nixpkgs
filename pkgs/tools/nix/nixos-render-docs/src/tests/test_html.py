import nixos_render_docs as nrd
import pytest
import textwrap

from sample_md import sample1

class Renderer(nrd.html.HTMLRenderer):
    def _pull_image(self, src: str) -> str:
        return src

class Converter(nrd.md.Converter[nrd.html.HTMLRenderer]):
    def __init__(self, manpage_urls: dict[str, str], xrefs: dict[str, nrd.manual_structure.XrefTarget]):
        super().__init__()
        self._renderer = Renderer(manpage_urls, xrefs)

def unpretty(s: str) -> str:
    return "".join(map(str.strip, s.splitlines())).replace('␣', ' ').replace('↵', '\n')

def test_lists_styles() -> None:
    # nested lists rotate through a number of list style
    c = Converter({}, {})
    assert c._render("- - - - foo") == unpretty("""
      <div class="itemizedlist"><ul class="itemizedlist compact" style="list-style-type: disc;">
       <li class="listitem">
        <div class="itemizedlist"><ul class="itemizedlist compact" style="list-style-type: circle;">
         <li class="listitem">
          <div class="itemizedlist"><ul class="itemizedlist compact" style="list-style-type: square;">
           <li class="listitem">
            <div class="itemizedlist"><ul class="itemizedlist compact" style="list-style-type: disc;">
             <li class="listitem"><p>foo</p></li>
            </ul></div>
           </li>
          </ul></div>
         </li>
        </ul></div>
       </li>
      </ul></div>
    """)
    assert c._render("1. 1. 1. 1. 1. 1. foo") == unpretty("""
      <div class="orderedlist"><ol class="orderedlist compact"  type="1">
       <li class="listitem">
        <div class="orderedlist"><ol class="orderedlist compact"  type="a">
         <li class="listitem">
          <div class="orderedlist"><ol class="orderedlist compact"  type="i">
           <li class="listitem">
            <div class="orderedlist"><ol class="orderedlist compact"  type="A">
             <li class="listitem">
              <div class="orderedlist"><ol class="orderedlist compact"  type="I">
               <li class="listitem">
                <div class="orderedlist"><ol class="orderedlist compact"  type="1">
                 <li class="listitem"><p>foo</p></li>
                </ol></div>
               </li>
              </ol></div>
             </li>
            </ol></div>
           </li>
          </ol></div>
         </li>
        </ol></div>
       </li>
      </ol></div>
    """)

def test_xrefs() -> None:
    # nested lists rotate through a number of list style
    c = Converter({}, {
        'foo': nrd.manual_structure.XrefTarget('foo', '<hr/>', 'toc1', 'title1', 'index.html'),
        'bar': nrd.manual_structure.XrefTarget('bar', '<br/>', 'toc2', 'title2', 'index.html', True),
    })
    assert c._render("[](#foo)") == '<p><a class="xref" href="index.html#foo" title="title1" ><hr/></a></p>'
    assert c._render("[](#bar)") == '<p><a class="xref" href="index.html" title="title2" ><br/></a></p>'
    with pytest.raises(nrd.html.UnresolvedXrefError) as exc:
        c._render("[](#baz)")
    assert exc.value.args[0] == 'bad local reference, id #baz not known'

def test_images() -> None:
    c = Converter({}, {})
    assert c._render("![*alt text*](foo \"title text\")") == unpretty("""
      <p>
       <div class="mediaobject">
        <img src="foo" alt="*alt text*" title="title text" />
       </div>
      </p>
    """)

def test_tables() -> None:
    c = Converter({}, {})
    assert c._render(textwrap.dedent("""
      | d | l | m | r |
      |---|:--|:-:|--:|
      | a | b | c | d |
    """)) == unpretty("""
      <div class="informaltable">
       <table class="informaltable" border="1">
        <colgroup>
         <col align="left" />
         <col align="left" />
         <col align="center" />
         <col align="right" />
        </colgroup>
        <thead>
         <tr>
          <th align="left">d</th>
          <th align="left">l</th>
          <th align="center">m</th>
          <th align="right">r</th>
         </tr>
        </thead>
        <tbody>
         <tr>
          <td align="left">a</td>
          <td align="left">b</td>
          <td align="center">c</td>
          <td align="right">d</td>
         </tr>
        </tbody>
       </table>
      </div>
    """)

def test_footnotes() -> None:
    c = Converter({}, {
        "bar": nrd.manual_structure.XrefTarget("bar", "", None, None, ""),
        "bar.__back.0": nrd.manual_structure.XrefTarget("bar.__back.0", "", None, None, ""),
        "bar.__back.1": nrd.manual_structure.XrefTarget("bar.__back.1", "", None, None, ""),
    })
    assert c._render(textwrap.dedent("""
      foo [^bar] baz [^bar]

      [^bar]: note
    """)) == unpretty("""
      <p>
       foo <a href="#bar" class="footnote" id="bar.__back.0"><sup class="footnote">[1]</sup></a>␣
       baz <a href="#bar" class="footnote" id="bar.__back.1"><sup class="footnote">[1]</sup></a>
      </p>
      <div class="footnotes">
       <br />
       <hr style="width:100; text-align:left;margin-left: 0" />
       <div id="bar" class="footnote">
         <p>
          note<a href="#bar.__back.0" class="para"><sup class="para">[1]</sup></a>
          <a href="#bar.__back.1" class="para"><sup class="para">[1]</sup></a>
         </p>
        </div>
       </div>
    """)

def test_full() -> None:
    c = Converter({ 'man(1)': 'http://example.org' }, {})
    assert c._render(sample1) == unpretty("""
        <div class="warning">
         <h3 class="title">Warning</h3>
         <p>foo</p>
         <div class="note">
          <h3 class="title">Note</h3>
          <p>nested</p>
         </div>
        </div>
        <p>
         <a class="link" href="link"  target="_top">↵
          multiline↵
         </a>
        </p>
        <p>
         <a class="link" href="http://example.org" target="_top">
          <span class="citerefentry"><span class="refentrytitle">man</span>(1)</span>
         </a> reference
        </p>
        <p><a id="b" />some <a id="a" />nested anchors</p>
        <p>
         <span class="emphasis"><em>emph</em></span>␣
         <span class="strong"><strong>strong</strong></span>␣
         <span class="emphasis"><em>nesting emph <span class="strong"><strong>and strong</strong></span>␣
         and <code class="literal">code</code></em></span>
        </p>
        <div class="itemizedlist">
         <ul class="itemizedlist " style="list-style-type: disc;">
          <li class="listitem"><p>wide bullet</p></li>
          <li class="listitem"><p>list</p></li>
         </ul>
        </div>
        <div class="orderedlist">
         <ol class="orderedlist "  type="1">
          <li class="listitem"><p>wide ordered</p></li>
          <li class="listitem"><p>list</p></li>
         </ol>
        </div>
        <div class="itemizedlist">
         <ul class="itemizedlist compact" style="list-style-type: disc;">
          <li class="listitem"><p>narrow bullet</p></li>
          <li class="listitem"><p>list</p></li>
         </ul>
        </div>
        <div class="orderedlist">
         <ol class="orderedlist compact"  type="1">
          <li class="listitem"><p>narrow ordered</p></li>
          <li class="listitem"><p>list</p></li>
         </ol>
        </div>
        <div class="blockquote">
         <blockquote class="blockquote">
          <p>quotes</p>
          <div class="blockquote">
           <blockquote class="blockquote">
            <p>with <span class="emphasis"><em>nesting</em></span></p>
            <pre>
             <code class="programlisting">
              nested code block↵
             </code>
            </pre>
           </blockquote>
          </div>
          <div class="itemizedlist">
           <ul class="itemizedlist compact" style="list-style-type: disc;">
            <li class="listitem"><p>and lists</p></li>
            <li class="listitem">
             <pre>
              <code class="programlisting">
               containing code↵
              </code>
             </pre>
            </li>
           </ul>
          </div>
          <p>and more quote</p>
         </blockquote>
        </div>
        <div class="orderedlist">
         <ol class="orderedlist compact" start="100" type="1">
          <li class="listitem"><p>list starting at 100</p></li>
          <li class="listitem"><p>goes on</p></li>
         </ol>
        </div>
        <div class="variablelist">
         <dl class="variablelist">
          <dt><span class="term">deflist</span></dt>
          <dd>
           <div class="blockquote">
            <blockquote class="blockquote">
             <p>
              with a quote↵
              and stuff
             </p>
            </blockquote>
           </div>
           <pre>
            <code class="programlisting">
             code block↵
            </code>
           </pre>
           <pre>
            <code class="programlisting">
             fenced block↵
            </code>
           </pre>
           <p>text</p>
          </dd>
          <dt><span class="term">more stuff in same deflist</span></dt>
          <dd>
           <p>foo</p>
          </dd>
         </dl>
        </div>""")
