from collections.abc import MutableMapping, Sequence
from frozendict import frozendict # type: ignore[attr-defined]
from typing import Any, Optional

import markdown_it
from markdown_it.token import Token
from markdown_it.utils import OptionsDict
from xml.sax.saxutils import escape, quoteattr

_xml_id_translate_table = {
    ord('*'): ord('_'),
    ord('<'): ord('_'),
    ord(' '): ord('_'),
    ord('>'): ord('_'),
    ord('['): ord('_'),
    ord(']'): ord('_'),
    ord(':'): ord('_'),
    ord('"'): ord('_'),
}
def make_xml_id(s: str) -> str:
    return s.translate(_xml_id_translate_table)

class DocBookRenderer(markdown_it.renderer.RendererProtocol):
    __output__ = "docbook"
    def __init__(self, parser: Optional[markdown_it.MarkdownIt] = None):
        self.rules = {
            'text': self.text,
            'paragraph_open': self.paragraph_open,
            'paragraph_close': self.paragraph_close,
            'hardbreak': self.hardbreak,
            'softbreak': self.softbreak,
            'code_inline': self.code_inline,
            'code_block': self.code_block,
            'link_open': self.link_open,
            'link_close': self.link_close,
            'list_item_open': self.list_item_open,
            'list_item_close': self.list_item_close,
            'bullet_list_open': self.bullet_list_open,
            'bullet_list_close': self.bullet_list_close,
            'em_open': self.em_open,
            'em_close': self.em_close,
            'strong_open': self.strong_open,
            'strong_close': self.strong_close,
            'fence': self.fence,
            'blockquote_open': self.blockquote_open,
            'blockquote_close': self.blockquote_close,
            'dl_open': self.dl_open,
            'dl_close': self.dl_close,
            'dt_open': self.dt_open,
            'dt_close': self.dt_close,
            'dd_open': self.dd_open,
            'dd_close': self.dd_close,
            'myst_role': self.myst_role,
            "container_{.note}_open": self.note_open,
            "container_{.note}_close": self.note_close,
            "container_{.important}_open": self.important_open,
            "container_{.important}_close": self.important_close,
            "container_{.warning}_open": self.warning_open,
            "container_{.warning}_close": self.warning_close,
        }
    def render(self, tokens: Sequence[Token], options: OptionsDict,
               env: MutableMapping[str, Any]) -> str:
        assert '-link-tag-stack' not in env
        env['-link-tag-stack'] = []
        assert '-deflist-stack' not in env
        env['-deflist-stack'] = []
        def do_one(i: int, token: Token) -> str:
            if token.type == "inline":
                assert token.children is not None
                return self.renderInline(token.children, options, env)
            elif token.type in self.rules:
                return self.rules[token.type](tokens[i], tokens, i, options, env)
            else:
                raise NotImplementedError("md token not supported yet", token)
        return "".join(map(lambda arg: do_one(*arg), enumerate(tokens)))
    def renderInline(self, tokens: Sequence[Token], options: OptionsDict,
                     env: MutableMapping[str, Any]) -> str:
        # HACK to support docbook links and xrefs. link handling is only necessary because the docbook
        # manpage stylesheet converts - in urls to a mathematical minus, which may be somewhat incorrect.
        for i, token in enumerate(tokens):
            if token.type != 'link_open':
                continue
            token.tag = 'link'
            # turn [](#foo) into xrefs
            if token.attrs['href'][0:1] == '#' and tokens[i + 1].type == 'link_close': # type: ignore[index]
                token.tag = "xref"
            # turn <x> into links without contents
            if tokens[i + 1].type == 'text' and tokens[i + 1].content == token.attrs['href']:
                tokens[i + 1].content = ''

        def do_one(i: int, token: Token) -> str:
            if token.type in self.rules:
                return self.rules[token.type](tokens[i], tokens, i, options, env)
            else:
                raise NotImplementedError("md node not supported yet", token)
        return "".join(map(lambda arg: do_one(*arg), enumerate(tokens)))

    def text(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
             env: MutableMapping[str, Any]) -> str:
        return escape(token.content)
    def paragraph_open(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                       env: MutableMapping[str, Any]) -> str:
        return "<para>"
    def paragraph_close(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                        env: MutableMapping[str, Any]) -> str:
        return "</para>"
    def hardbreak(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                  env: MutableMapping[str, Any]) -> str:
        return "<literallayout>\n</literallayout>"
    def softbreak(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                  env: MutableMapping[str, Any]) -> str:
        # should check options.breaks() and emit hard break if so
        return "\n"
    def code_inline(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                    env: MutableMapping[str, Any]) -> str:
        return f"<literal>{escape(token.content)}</literal>"
    def code_block(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                   env: MutableMapping[str, Any]) -> str:
        return f"<programlisting>{escape(token.content)}</programlisting>"
    def link_open(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                  env: MutableMapping[str, Any]) -> str:
        env['-link-tag-stack'].append(token.tag)
        (attr, start) = ('linkend', 1) if token.attrs['href'][0] == '#' else ('xlink:href', 0)
        return f"<{token.tag} {attr}={quoteattr(token.attrs['href'][start:])}>"
    def link_close(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                   env: MutableMapping[str, Any]) -> str:
        return f"</{env['-link-tag-stack'].pop()}>"
    def list_item_open(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                       env: MutableMapping[str, Any]) -> str:
        return "<listitem>"
    def list_item_close(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                        env: MutableMapping[str, Any]) -> str:
        return "</listitem>\n"
    # HACK open and close para for docbook change size. remove soon.
    def bullet_list_open(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                         env: MutableMapping[str, Any]) -> str:
        return "<para><itemizedlist>\n"
    def bullet_list_close(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                          env: MutableMapping[str, Any]) -> str:
        return "\n</itemizedlist></para>"
    def em_open(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                env: MutableMapping[str, Any]) -> str:
        return "<emphasis>"
    def em_close(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                 env: MutableMapping[str, Any]) -> str:
        return "</emphasis>"
    def strong_open(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                    env: MutableMapping[str, Any]) -> str:
        return "<emphasis role=\"strong\">"
    def strong_close(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                     env: MutableMapping[str, Any]) -> str:
        return "</emphasis>"
    def fence(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
              env: MutableMapping[str, Any]) -> str:
        info = f" language={quoteattr(token.info)}" if token.info != "" else ""
        return f"<programlisting{info}>{escape(token.content)}</programlisting>"
    def blockquote_open(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                        env: MutableMapping[str, Any]) -> str:
        return "<para><blockquote>"
    def blockquote_close(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                         env: MutableMapping[str, Any]) -> str:
        return "</blockquote></para>"
    def note_open(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                  env: MutableMapping[str, Any]) -> str:
        return "<para><note>"
    def note_close(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                   env: MutableMapping[str, Any]) -> str:
        return "</note></para>"
    def important_open(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                       env: MutableMapping[str, Any]) -> str:
        return "<para><important>"
    def important_close(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                        env: MutableMapping[str, Any]) -> str:
        return "</important></para>"
    def warning_open(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                     env: MutableMapping[str, Any]) -> str:
        return "<para><warning>"
    def warning_close(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                      env: MutableMapping[str, Any]) -> str:
        return "</warning></para>"
    # markdown-it emits tokens based on the html syntax tree, but docbook is
    # slightly different. html has <dl>{<dt/>{<dd/>}}</dl>,
    # docbook has <variablelist>{<varlistentry><term/><listitem/></varlistentry>}<variablelist>
    # we have to reject multiple definitions for the same term for time being.
    def dl_open(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                env: MutableMapping[str, Any]) -> str:
        env['-deflist-stack'].append({})
        return "<para><variablelist>"
    def dl_close(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                 env: MutableMapping[str, Any]) -> str:
        env['-deflist-stack'].pop()
        return "</variablelist></para>"
    def dt_open(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                env: MutableMapping[str, Any]) -> str:
        env['-deflist-stack'][-1]['has-dd'] = False
        return "<varlistentry><term>"
    def dt_close(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                 env: MutableMapping[str, Any]) -> str:
        return "</term>"
    def dd_open(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                env: MutableMapping[str, Any]) -> str:
        if env['-deflist-stack'][-1]['has-dd']:
            raise Exception("multiple definitions per term not supported")
        env['-deflist-stack'][-1]['has-dd'] = True
        return "<listitem>"
    def dd_close(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                 env: MutableMapping[str, Any]) -> str:
        return "</listitem></varlistentry>"
    def myst_role(self, token: Token, tokens: Sequence[Token], i: int, options: OptionsDict,
                  env: MutableMapping[str, Any]) -> str:
        if token.meta['name'] == 'command':
            return f"<command>{escape(token.content)}</command>"
        if token.meta['name'] == 'file':
            return f"<filename>{escape(token.content)}</filename>"
        if token.meta['name'] == 'var':
            return f"<varname>{escape(token.content)}</varname>"
        if token.meta['name'] == 'env':
            return f"<envar>{escape(token.content)}</envar>"
        if token.meta['name'] == 'option':
            return f"<option>{escape(token.content)}</option>"
        if token.meta['name'] == 'manpage':
            [page, section] = [ s.strip() for s in token.content.rsplit('(', 1) ]
            section = section[:-1]
            man = f"{page}({section})"
            title = f"<refentrytitle>{escape(page)}</refentrytitle>"
            vol = f"<manvolnum>{escape(section)}</manvolnum>"
            ref = f"<citerefentry>{title}{vol}</citerefentry>"
            if man in env['manpage_urls']:
                return f"<link xlink:href={quoteattr(env['manpage_urls'][man])}>{ref}</link>"
            else:
                return ref
        raise NotImplementedError("md node not supported yet", token)
