#!/usr/bin/env -S sed -nEf

# Small sed script to find (possible) problems.
# Particularly to be used on update to a new gcide version.
#
# To be run before webfmt.
# For each test, below the action formerly in post_webfmt.sed.
#  - disregarding whether it is a good one or not.
#
# If this script prints anything, webfmt probably fails.
#


\`<col>([^<]*),? <cd>([^<]*)</col>` p
#s`<col>([^<]*),? <cd>([^<]*)</col>`<col>\1</col>, <cd>\2`g

\`<qau>([^<]*)(<break>)` p
#s`<qau>([^<]*)(<break>)`<qau>\1</qau>\2`

\`^([^<]*)</qau>` p
#s`^([^<]*)</qau>`\1`

\`^([^<]*)</au>` p
#s`^([^<]*)</au>`\1`

\`</>` p
#s`</>``g
