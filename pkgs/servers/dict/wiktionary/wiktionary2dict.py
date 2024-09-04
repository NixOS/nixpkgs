# Adapted to produce DICT-compatible files by Petr Rockai in 2012
# Based on code from wiktiondict by Greg Hewgill
import re
import sys
import os
import textwrap
import time
import xml.sax

class Text:
    def __init__(self, s):
        self.s = s
    def process(self):
        return s

class TemplateCall:
    def __init__(self):
        pass
    def process(self):
        pass

class Template:
    def __init__(self):
        self.parts = []
    def append(self, part):
        self.parts.append(part)
    def process(self):
        return ''.join(x.process() for x in self.parts)

class Whitespace:
    def __init__(self, s):
        self.s = s

class OpenDouble: pass
class OpenTriple: pass
class CloseDouble: pass
class CloseTriple: pass

class Equals:
    def __str__(self):
        return "="

class Delimiter:
    def __init__(self, c):
        self.c = c
    def __str__(self):
        return self.c

def Tokenise(s):
    s = str(s)
    stack = []
    last = 0
    i = 0
    while i < len(s):
        if s[i] == '{' and i+1 < len(s) and s[i+1] == '{':
            if i > last:
                yield s[last:i]
            if i+2 < len(s) and s[i+2] == '{':
                yield OpenTriple()
                stack.append(3)
                i += 3
            else:
                yield OpenDouble()
                stack.append(2)
                i += 2
            last = i
        elif s[i] == '}' and i+1 < len(s) and s[i+1] == '}':
            if i > last:
                yield s[last:i]
            if len(stack) == 0:
                yield "}}"
                i += 2
            elif stack[-1] == 2:
                yield CloseDouble()
                i += 2
                stack.pop()
            elif i+2 < len(s) and s[i+2] == '}':
                yield CloseTriple()
                i += 3
                stack.pop()
            else:
                raise SyntaxError()
            last = i
        elif s[i] == ':' or s[i] == '|':
            if i > last:
                yield s[last:i]
            yield Delimiter(s[i])
            i += 1
            last = i
        elif s[i] == '=':
            if i > last:
                yield s[last:i]
            yield Equals()
            i += 1
            last = i
        #elif s[i] == ' ' or s[i] == '\t' or s[i] == '\n':
        #    if i > last:
        #        yield s[last:i]
        #    last = i
        #    m = re.match(r"\s+", s[i:])
        #    assert m
        #    yield Whitespace(m.group(0))
        #    i += len(m.group(0))
        #    last = i
        else:
            i += 1
    if i > last:
        yield s[last:i]

def processSub(templates, tokens, args):
    t = next(tokens)
    if not isinstance(t, str):
        raise SyntaxError
    name = t
    t = next(tokens)
    default = None
    if isinstance(t, Delimiter) and t.c == '|':
        default = ""
        while True:
            t = next(tokens)
            if isinstance(t, str):
                default += t
            elif isinstance(t, OpenDouble):
                default += processTemplateCall(templates, tokens, args)
            elif isinstance(t, OpenTriple):
                default += processSub(templates, tokens, args)
            elif isinstance(t, CloseTriple):
                break
            else:
                print("Unexpected:", t)
                raise SyntaxError()
    if name in args:
        return args[name]
    if default is not None:
        return default
    if name == "lang":
        return "en"
    return "{{{%s}}}" % name

def processTemplateCall(templates, tokens, args):
    template = tokens.next().strip().lower()
    args = {}
    a = 1
    t = next(tokens)
    while True:
        if isinstance(t, Delimiter):
            name = str(a)
            arg = ""
            while True:
                t = next(tokens)
                if isinstance(t, str):
                    arg += t
                elif isinstance(t, OpenDouble):
                    arg += processTemplateCall(templates, tokens, args)
                elif isinstance(t, OpenTriple):
                    arg += processSub(templates, tokens, args)
                elif isinstance(t, Delimiter) and t.c != '|':
                    arg += str(t)
                else:
                    break
            if isinstance(t, Equals):
                name = arg.strip()
                arg = ""
                while True:
                    t = next(tokens)
                    if isinstance(t, (str, Equals)):
                        arg += str(t)
                    elif isinstance(t, OpenDouble):
                        arg += processTemplateCall(templates, tokens, args)
                    elif isinstance(t, OpenTriple):
                        arg += processSub(templates, tokens, args)
                    elif isinstance(t, Delimiter) and t.c != '|':
                        arg += str(t)
                    else:
                        break
                arg = arg.strip()
            else:
                a += 1
            args[name] = arg
        elif isinstance(t, CloseDouble):
            break
        else:
            print("Unexpected:", t)
            raise SyntaxError
    #print template, args
    if template[0] == '#':
        if template == "#if":
            if args['1'].strip():
                return args['2']
            elif '3' in args:
                return args['3']
            else:
                return ""
        elif template == "#ifeq":
            if args['1'].strip() == args['2'].strip():
                return args['3']
            elif '4' in args:
                return args['4']
            else:
                return ""
        elif template == "#ifexist":
            return ""
        elif template == "#switch":
            sw = args['1'].strip()
            if sw in args:
                return args[sw]
            else:
                return ""
        else:
            print("Unknown ParserFunction:", template)
            sys.exit(1)
    if template not in templates:
        return "{{%s}}" % template
    return process(templates, templates[template], args)

def process(templates, s, args = {}):
    s = re.compile(r"<!--.*?-->", re.DOTALL).sub("", s)
    s = re.compile(r"<noinclude>.*?</noinclude>", re.DOTALL).sub("", s)
    assert "<onlyinclude>" not in s
    #s = re.sub(r"(.*?)<onlyinclude>(.*?)</onlyinclude>(.*)", r"\1", s)
    s = re.compile(r"<includeonly>(.*?)</includeonly>", re.DOTALL).sub(r"\1", s)
    r = ""
    #print list(Tokenise(s))
    tokens = Tokenise(s)
    try:
        while True:
            t = next(tokens)
            if isinstance(t, OpenDouble):
                r += processTemplateCall(templates, tokens, args)
            elif isinstance(t, OpenTriple):
                r += processSub(templates, tokens, args)
            else:
                r += str(t)
    except StopIteration:
        pass
    return r

def test():
    templates = {
        'lb': "{{",
        'name-example': "I am a template example, my first name is '''{{{firstName}}}''' and my last name is '''{{{lastName}}}'''. You can reference my page at [[{{{lastName}}}, {{{firstName}}}]].",
        't': "start-{{{1|pqr}}}-end",
        't0': "start-{{{1}}}-end",
        't1': "start{{{1}}}end<noinclude>moo</noinclude>",
        't2a1': "{{t2demo|a|{{{1}}}}}",
        't2a2': "{{t2demo|a|2={{{1}}}}}",
        't2demo': "start-{{{1}}}-middle-{{{2}}}-end",
        't5': "{{t2demo|{{{a}}}=b}}",
        't6': "t2demo|a",
    }
    def t(text, expected):
        print("text:", text)
        s = process(templates, text)
        if s != expected:
            print("got:", s)
            print("expected:", expected)
            sys.exit(1)
    t("{{Name-example}}", "I am a template example, my first name is '''{{{firstName}}}''' and my last name is '''{{{lastName}}}'''. You can reference my page at [[{{{lastName}}}, {{{firstName}}}]].")
    t("{{Name-example | firstName=John | lastName=Smith }}", "I am a template example, my first name is '''John''' and my last name is '''Smith'''. You can reference my page at [[Smith, John]].")
    t("{{t0|a}}", "start-a-end")
    t("{{t0| }}", "start- -end")
    t("{{t0|}}", "start--end")
    t("{{t0}}", "start-{{{1}}}-end")
    t("{{t0|     }}", "start-     -end")
    t("{{t0|\n}}", "start-\n-end")
    t("{{t0|1=     }}", "start--end")
    t("{{t0|1=\n}}", "start--end")
    t("{{T}}", "start-pqr-end")
    t("{{T|}}", "start--end")
    t("{{T|abc}}", "start-abc-end")
    t("{{T|abc|def}}", "start-abc-end")
    t("{{T|1=abc|1=def}}", "start-def-end")
    t("{{T|abc|1=def}}", "start-def-end")
    t("{{T|1=abc|def}}", "start-def-end")
    t("{{T|{{T}}}}", "start-start-pqr-end-end")
    t("{{T|{{T|{{T}}}}}}", "start-start-start-pqr-end-end-end")
    t("{{T|{{T|{{T|{{T}}}}}}}}", "start-start-start-start-pqr-end-end-end-end")
    t("{{T|a{{t|b}}}}", "start-astart-b-end-end")
    t("{{T|{{T|a=b}}}}", "start-start-pqr-end-end")
    t("{{T|a=b}}", "start-pqr-end")
    t("{{T|1=a=b}}", "start-a=b-end")
    #t("{{t1|{{lb}}tc}}}}", "start{{tcend}}")
    #t("{{t2a1|1=x=y}}", "start-a-middle-{{{2}}}-end")
    #t("{{t2a2|1=x=y}}", "start-a-middle-x=y-end")
    #t("{{t5|a=2=d}}", "start-{{{1}}}-middle-d=b-end")
    #t("{{ {{t6}} }}", "{{ t2demo|a }}")
    t("{{t|[[a|b]]}}", "start-b-end")
    t("{{t|[[a|b]] }}", "start-b -end")

Parts = {
    # Standard POS headers
    'noun': "n.",
    'Noun': "n.",
    'Noun 1': "n.",
    'Noun 2': "n.",
    'Verb': "v.",
    'Adjective': "adj.",
    'Adverb': "adv.",
    'Pronoun': "pron.",
    'Conjunction': "conj.",
    'Interjection': "interj.",
    'Preposition': "prep.",
    'Proper noun': "n.p.",
    'Proper Noun': "n.p.",
    'Article': "art.",

    # Standard non-POS level 3 headers
    '{{acronym}}': "acr.",
    'Acronym': "acr.",
    '{{abbreviation}}': "abbr.",
    '[[Abbreviation]]': "abbr.",
    'Abbreviation': "abbr.",
    '[[initialism]]': "init.",
    '{{initialism}}': "init.",
    'Initialism': "init.",
    'Contraction': "cont.",
    'Prefix': "prefix",
    'Suffix': "suffix",
    'Symbol': "sym.",
    'Letter': "letter",
    'Idiom': "idiom",
    'Idioms': "idiom",
    'Phrase': "phrase",

    # Debated POS level 3 headers
    'Number': "num.",
    'Numeral': "num.",
    'Cardinal number': "num.",
    'Ordinal number': "num.",
    'Cardinal numeral': "num.",
    'Ordinal numeral': "num.",

    # Other headers in use
    'Personal pronoun': "pers.pron.",
    'Adjective/Adverb': "adj./adv.",
    'Proper adjective': "prop.adj.",
    'Determiner': "det.",
    'Demonstrative determiner': "dem.det.",
    'Clitic': "clitic",
    'Infix': "infix",
    'Counter': "counter",
    'Kanji': None,
    'Kanji reading': None,
    'Hiragana letter': None,
    'Katakana letter': None,
    'Pinyin': None,
    'Han character': None,
    'Hanzi': None,
    'Hanja': None,
    'Proverb': "prov.",
    'Expression': None,
    'Adjectival noun': None,
    'Quasi-adjective': None,
    'Particle': "part.",
    'Infinitive particle': "part.",
    'Possessive adjective': "poss.adj.",
    'Verbal prefix': "v.p.",
    'Postposition': "post.",
    'Prepositional article': "prep.art.",
    'Phrasal verb': "phr.v.",
    'Participle': "participle",
    'Interrogative auxiliary verb': "int.aux.v.",
    'Pronominal adverb': "pron.adv.",
    'Adnominal': "adn.",
    'Abstract pronoun': "abs.pron.",
    'Conjunction particle': None,
    'Root': "root",

    # Non-standard, deprecated headers
    'Noun form': "n.",
    'Verb form': "v.",
    'Adjective form': "adj.form.",
    'Nominal phrase': "nom.phr.",
    'Noun phrase': "n. phrase",
    'Verb phrase': "v. phrase",
    'Transitive verb': "v.t.",
    'Intransitive verb': "v.i.",
    'Reflexive verb': "v.r.",
    'Cmavo': None,
    'Romaji': "rom.",
    'Hiragana': None,
    'Furigana': None,
    'Compounds': None,

    # Other headers seen
    'Alternative forms': None,
    'Alternative spellings': None,
    'Anagrams': None,
    'Antonym': None,
    'Antonyms': None,
    'Conjugation': None,
    'Declension': None,
    'Declension and pronunciations': None,
    'Definite Article': "def.art.",
    'Definite article': "def.art.",
    'Demonstrative pronoun': "dem.pron.",
    'Derivation': None,
    'Derived expression': None,
    'Derived expressions': None,
    'Derived forms': None,
    'Derived phrases': None,
    'Derived terms': None,
    'Derived, Related terms': None,
    'Descendants': None,
    #'Etymology': None,
    #'Etymology 1': None,
    #'Etymology 2': None,
    #'Etymology 3': None,
    #'Etymology 4': None,
    #'Etymology 5': None,
    'Examples': None,
    'External links': None,
    '[[Gismu]]': None,
    'Gismu': None,
    'Homonyms': None,
    'Homophones': None,
    'Hyphenation': None,
    'Indefinite article': "art.",
    'Indefinite pronoun': "ind.pron.",
    'Indefinite Pronoun': "ind.pron.",
    'Indetermined pronoun': "ind.pron.",
    'Interrogative conjunction': "int.conj.",
    'Interrogative determiner': "int.det.",
    'Interrogative particle': "int.part.",
    'Interrogative pronoun': "int.pron.",
    'Legal expression': "legal",
    'Mass noun': "n.",
    'Miscellaneous': None,
    'Mutations': None,
    'Noun and verb': "n/v.",
    'Other language': None,
    'Pinyin syllable': None,
    'Possessive determiner': "poss.det.",
    'Possessive pronoun': "poss.pron.",
    'Prepositional phrase': "prep.phr.",
    'Prepositional Pronoun': "prep.pron.",
    'Pronunciation': None,
    'Pronunciation 1': None,
    'Pronunciation 2': None,
    'Quotations': None,
    'References': None,
    'Reflexive pronoun': "refl.pron.",
    'Related expressions': None,
    'Related terms': None,
    'Related words': None,
    'Relative pronoun': "rel.pron.",
    'Saying': "saying",
    'See also': None,
    'Shorthand': None,
    '[http://en.wikipedia.org/wiki/Shorthand Shorthand]': None,
    'Sister projects': None,
    'Spelling note': None,
    'Synonyms': None,
    'Translation': None,
    'Translations': None,
    'Translations to be checked': None,
    'Transliteration': None,
    'Trivia': None,
    'Usage': None,
    'Usage in English': None,
    'Usage notes': None,
    'Verbal noun': "v.n.",
}
PartsUsed = {}
for p in list(Parts.keys()):
    PartsUsed[p] = 0

def encode(s):
    r = e(s)
    assert r[1] == len(s)
    return r[0]

def dowikilink(m):
    a = m.group(1).split("|")
    if len(a) > 1:
        link = a[1]
    else:
        link = a[0]
    if ':' in link:
        link = ""
    return link

seentemplates = {}
def dotemplate(m):
    aa = m.group(1).split("|")
    args = {}
    n = 0
    for a in aa:
        am = re.match(r"(.*?)(=(.*))?", a)
        if am:
            args[am.group(1)] = am.group(3)
        else:
            n += 1
            args[n] = am.group(1)

    #if aa[0] in seentemplates:
    #    seentemplates[aa[0]] += 1
    #else:
    #    seentemplates[aa[0]] = 1
    #    print len(seentemplates), aa[0]
    #print aa[0]

    #if aa[0] not in Templates:
    #    return "(unknown template %s)" % aa[0]
    #body = Templates[aa[0]]
    #body = re.sub(r"<noinclude>.*?</noinclude>", "", body)
    #assert "<onlyinclude>" not in body
    ##body = re.sub(r"(.*?)<onlyinclude>(.*?)</onlyinclude>(.*)", r"\1", body)
    #body = re.sub(r"<includeonly>(.*?)</includeonly>", r"\1", body)
    #def dotemplatearg(m):
    #    ta = m.group(1).split("|")
    #    if ta[0] in args:
    #        return args[ta[0]]
    #    elif len(ta) > 1:
    #        return ta[1]
    #    else:
    #        return "{{{%s}}}" % ta[0]
    #body = re.sub(r"{{{(.*?)}}}", dotemplatearg, body)
    #return dewiki(body)

def doparserfunction(m):
    a = m.group(2).split("|")
    if m.group(1) == "ifeq":
        if a[0] == a[1]:
            return a[2]
        elif len(a) >= 4:
            return a[3]
    return ""

def dewiki(body, indent = 0):
    # process in this order:
    #   {{{ }}}
    #   <> <>
    #   [[ ]]
    #   {{ }}
    #   ''' '''
    #   '' ''
    #body = wikimediatemplate.process(Templates, body)
    body = re.sub(r"\[\[(.*?)\]\]", dowikilink, body)
    #body = re.sub(r"{{(.*?)}}", dotemplate, body)
    #body = re.sub(r"{{#(.*?):(.*?)}}", doparserfunction, body)
    body = re.sub(r"'''(.*?)'''", r"\1", body)
    body = re.sub(r"''(.*?)''", r"\1", body)
    lines = body.split("\n")
    n = 0
    i = 0
    while i < len(lines):
        if len(lines[i]) > 0 and lines[i][0] == "#":
            if len(lines[i]) > 1 and lines[i][1] == '*':
                wlines = textwrap.wrap(lines[i][2:].strip(),
                    initial_indent = "    * ",
                    subsequent_indent = "      ")
            elif len(lines[i]) > 1 and lines[i][1] == ':':
                wlines = textwrap.wrap(lines[i][2:].strip(),
                    initial_indent = "        ",
                    subsequent_indent = "        ")
            else:
                n += 1
                wlines = textwrap.wrap(str(n) + ". " + lines[i][1:].strip(),
                    subsequent_indent = "   ")
        elif len(lines[i]) > 0 and lines[i][0] == "*":
            n = 0
            wlines = textwrap.wrap(lines[i][1:].strip(),
                initial_indent = "* ",
                subsequent_indent = "  ")
        else:
            n = 0
            wlines = textwrap.wrap(lines[i].strip())
            if len(wlines) == 0:
                wlines = ['']
        lines[i:i+1] = wlines
        i += len(wlines)
    return ''.join("  "*(indent-1)+x+"\n" for x in lines)

class WikiSection:
    def __init__(self, heading, body):
        self.heading = heading
        self.body = body
        #self.lines = re.split("\n+", body.strip())
        #if len(self.lines) == 1 and len(self.lines[0]) == 0:
        #    self.lines = []
        self.children = []
    def __str__(self):
        return "<%s:%i:%s>" % (self.heading, len(self.body or ""), ','.join([str(x) for x in self.children]))
    def add(self, section):
        self.children.append(section)

def parse(word, text):
    headings = list(re.finditer("^(=+)\s*(.*?)\s*=+\n", text, re.MULTILINE))
    #print [x.group(1) for x in headings]
    doc = WikiSection(word, "")
    stack = [doc]
    for i, m in enumerate(headings):
        depth = len(m.group(1))
        if depth < len(stack):
            stack = stack[:depth]
        else:
            while depth > len(stack):
                s = WikiSection(None, "")
                stack[-1].add(s)
                stack.append(s)
        if i+1 < len(headings):
            s = WikiSection(m.group(2), text[m.end(0):headings[i+1].start(0)].strip())
        else:
            s = WikiSection(m.group(2), text[m.end(0):].strip())
        assert len(stack) == depth
        stack[-1].add(s)
        stack.append(s)
    #while doc.heading is None and len(doc.lines) == 0 and len(doc.children) == 1:
    #    doc = doc.children[0]
    return doc

def formatFull(word, doc):
    def f(depth, section):
        if section.heading:
            r = "  "*(depth-1) + section.heading + "\n\n"
        else:
            r = ""
        if section.body:
            r += dewiki(section.body, depth+1)+"\n"
        #r += "".join("  "*depth + x + "\n" for x in dewiki(section.body))
        #if len(section.lines) > 0:
        #    r += "\n"
        for c in section.children:
            r += f(depth+1, c)
        return r
    s = f(0, doc)
    s += "Ref: http://en.wiktionary.org/wiki/%s\n" % word
    return s

def formatNormal(word, doc):
    def f(depth, posdepth, section):
        r = ""
        if depth == posdepth:
            if not section.heading or section.heading.startswith("Etymology"):
                posdepth += 1
            elif section.heading in Parts:
                #p = Parts[section.heading]
                #if p:
                #    r += "  "*(depth-1) + word + " (" + p + ")\n\n"
                r += "  "*(depth-1) + section.heading + "\n\n"
            else:
                print("Unknown part: (%s) %s" % (word, section.heading), file=errors)
                return ""
        elif depth > posdepth:
            return ""
        elif section.heading:
            r += "  "*(depth-1) + section.heading + "\n\n"
        if section.body:
            r += dewiki(section.body, depth+1)+"\n"
        #r += "".join("  "*depth + x + "\n" for x in dewiki(section.lines))
        #if len(section.lines) > 0:
        #    r += "\n"
        for c in section.children:
            r += f(depth+1, posdepth, c)
        return r
    s = f(0, 3, doc)
    s += "Ref: http://en.wiktionary.org/wiki/%s\n" % word
    return s

def formatBrief(word, doc):
    def f(depth, posdepth, section):
        if depth == posdepth:
            h = section.heading
            if not section.heading or section.heading.startswith("Etymology"):
                posdepth += 1
            elif section.heading in Parts:
                #h = Parts[section.heading]
                #if h:
                #    h = "%s (%s)" % (word, h)
                pass
            stack.append([h, False])
        elif depth > 0:
            stack.append([section.heading, False])
        else:
            stack.append(["%h " + section.heading, False])
        r = ""
        #if section.heading:
        #    r += "  "*(depth-1) + section.heading + "\n"
        body = ''.join(x+"\n" for x in section.body.split("\n") if len(x) > 0 and x[0] == '#')
        if len(body) > 0:
            for i in range(len(stack)):
                if not stack[i][1]:
                    if stack[i][0]:
                        r += "  "*(i-1) + stack[i][0] + "\n"
                    stack[i][1] = True
            r += dewiki(body, depth+1)
        for c in section.children:
            r += f(depth+1, posdepth, c)
        stack.pop()
        return r
    stack = []
    s = f(0, 3, doc)
    s += "Ref: http://en.wiktionary.org/wiki/%s\n" % word
    return s

class WikiHandler(xml.sax.ContentHandler):
    def __init__(self):
        self.element = None
        self.page = None
        self.text = ""
        self.long = {}
    def startElement(self, name, attrs):
        #print "start", name, attrs
        self.element = name
    def endElement(self, name):
        #print "end", name
        if self.element == "text":
            if self.page:
                if self.page in self.long:
                    print(self.page, len(self.text))
                    print()
                self.doPage(self.page, self.text)
                self.page = None
            self.text = ""
        self.element = None
    def characters(self, content):
        #print "characters", content
        if self.element == "title":
            if self.checkPage(content):
                self.page = content
        elif self.element == "text":
            if self.page:
                self.text += content
                if len(self.text) > 100000 and self.page not in self.long:
                    self.long[self.page] = 1
    def checkPage(self, page):
        return False
    def doPage(self, page, text):
        pass

class TemplateHandler(WikiHandler):
    def checkPage(self, page):
        return page.startswith("Template:")
    def doPage(self, page, text):
        Templates[page[page.find(':')+1:].lower()] = text

class WordHandler(WikiHandler):
    def checkPage(self, page):
        return ':' not in page
    def doPage(self, page, text):
        m = re.match(r"#redirect\s*\[\[(.*?)\]\]", text, re.IGNORECASE)
        if m:
            out.write("  See <%s>" % page)
            return
        doc = parse(page, text)
        out.write(formatBrief(page, doc))
        #print formatBrief(page, doc)

fn = sys.argv[1]
info = """   This file was converted from the original database on:
             %s

   The original data is available from:
             http://en.wiktionary.org
   The version from which this file was generated was:
             %s

  Wiktionary is available under the GNU Free Documentation License.
""" % (time.ctime(), os.path.basename(fn))

errors = open("mkdict.err", "w")

Templates = {}
f = os.popen("bunzip2 -c %s" % fn, "r")
xml.sax.parse(f, TemplateHandler())
f.close()

f = os.popen("bunzip2 -c %s" % fn, "r")
out = os.popen("dictfmt -p wiktionary-en --locale en_US.UTF-8 --columns 0 -u http://en.wiktionary.org", "w")

out.write("%%h English Wiktionary\n%s" % info)
xml.sax.parse(f, WordHandler())
f.close()
out.close()
