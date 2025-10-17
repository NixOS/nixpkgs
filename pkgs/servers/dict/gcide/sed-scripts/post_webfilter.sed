#!/usr/bin/env -S sed -Ef

# SPDX-FileCopyrightText: 2017, 2018, 2025 Einhard Leichtfuß <alguien@respiranto.de>
# SPDX-License-Identifier: GPL-3.0-or-later

# Fix/adjust some syntax s.t. the parser (`webfmt`) can work with it (and
# produce decent output).
#
# To be run after `webfilter`, and before `webfmt`.
#


# Restrict to body (skip header).
/<hw>/,$ {

  # Merge "paragraphs" (delimited by empty lines).
  #  - The parser has problems with broken lines.
  #  - Also, this helps with the following s/// comands.
  /^$/ { p; d; }
  :a
  N
  s/\n(.)/ \1/
  t a


  # Remove book and publ tags in a qau element.
  #  - The parser fails otherwise.
  s`(<qau>[^<]*)(<book>|<publ>)([^<]*)(</book>|</publ>)`\1\3`g


  # Not accepted by parser.  Both single versions apparently translated in the
  # same way.
  s`(<(altname|contr)>)<cref>`\1`g
  s`</cref>(</(altname|contr)>)`\1`g

  # Not accepted by parser.  <ecol/> tags apparently ignored.
  s`(<(stype|prod)>)<ecol>`\1`g
  s`</ecol>(</(stype|prod)>)`\1`g

  # The parser would accept this, but yield a clearly broken result.
  #  - Debatable which tag pair better to keep.
  s`<prod>(<col>)`\1`g
  s`(</col>)</prod>`\1`g


  # Restrict <qau/> to the author themself (if extra info long).
  #  - In the webfilter output, the author info is broken into very short
  #    lines.
  #  - This is debatable.
  s`<qau>([^<]*) (\([^)]{20}[^<]*)</qau>`<qau>\1</qau> \2`g


  # Replace, e.g., '(<mcol><col>.+</col>), <col></col>(</mcol>)' -> '\1\2'.
  s`,?\s+<([a-z]+)></\1>\s*``g

}


# vi: ts=2 sw=0 et
