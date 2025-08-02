#!/usr/bin/env -S sed -Ef

s`(<altname>|<contr>)<cref>([^<]*)</cref>`\1\2`g
s`(<stype>|<prod>)<ecol>([^<]*)</ecol>`\1\2`g

# Restrict qau tag to the author themself.
s`<qau>([^<]*) (\([^)]{20}[^<]*)</qau>`<qau>\1</qau> \2`gp

# Replace for example, '(<mcol><col>.+</col>), <col></col>(</mcol>)' -> '\1'
s`,?\s+<([^>]*)></\1>\s*``g
