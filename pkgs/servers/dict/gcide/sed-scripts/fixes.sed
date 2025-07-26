#!/usr/bin/env -S sed -Ef

# A large part of the changes is derived from a diff between 0.48 and
# Debian's 0.48.5, excluding changes included in the new gcide release and
# those that do not change the final output.
#
# Sources:
# http://archive.debian.org/debian-archive/debian/pool/main/d/dict-gcide/dict-gcide_0.48.orig.tar.gz
# http://deb.debian.org/debian/pool/main/d/dict-gcide/dict-gcide_0.48.5.tar.xz

# TODO:
# * '[<source></source>]' (dict -d gcide duff)
# * '</item><item>' (dict -d gcide legislature)


## GENERAL

# Remove book and publ tags in a qau element.
# `webfmt' fails on <book>.
# `<publ>' seems to be removed by webfmt, so apparently not necessary to
# remove here.
s`(<qau>[^<]*)(<book>|<publ>)([^<]*)(</book>|</publ>)`\1\3`g


## CIDE.A

# Add presumably missing word.
\`^<mhw>\{ <hw>Ar"que\*bus</hw>, <hw>Ar"que\*buse</hw>  \}</mhw>` {
	s`(<def>A sort of hand gun or firearm) (a contrivance)`\1 with \2`
}


## CIDE.L

s`\<(province)w\>`\1`g


## S

s`measurments`measurements`g

# If one wanted to fix more than necessary (Debian does):
#\`^<hw>Ses\*quip"li\*cate</hw>` {
#	s`^`<p>`
#	s`<(/?)i>`<\1xex>`g
#
#	s`(<xex>)(a|b)(</xex>)<prime/`\1\2\\'\''b7\3`g
#	s`<prime/`\\'\''b7`
#}


## V

# Avoid double empty line in dict's output.
\`^<p><cs><col><b>Principle of virtual velocities</b>` {
	s`-(- <col><b>Virtual image</b></col>)`\1`
}
