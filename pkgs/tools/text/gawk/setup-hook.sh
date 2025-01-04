local oldOpts="-u"
shopt -qo nounset || oldOpts="+u"
set +u
. @gawk@/etc/profile.d/gawk.sh
gawklibpath_append @out@/lib/gawk
set "$oldOpts"
