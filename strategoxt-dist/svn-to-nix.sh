#! /bin/sh -v 

# Generate a Nix expression for the head revision of a directory in
# a subversion repository. The directory is assumed to contain
# a package with a configure.in file.
#
# Usage :
#
#   svn-to-nix.sh url
#
# where url points to a subversion repository

# Obtain version information from repository

# Revision

url=$1

rev=`svn log ${url} \
     | head -n 2 \
     | grep rev \
     | sed "s/rev \([0-9]*\):.*$/\1/"`

# The configure.in file

configure="/tmp/$$configure.in"
svn cat -r ${rev} ${url}/configure.in > $configure

# Version number from AC_INIT 

version=`grep AC_INIT $configure \
         | awk -F , -- "{print \\$2}" \
         | sed "s/[[]//" \
         | sed "s/[]]//"`

# Package name from AC_INIT

packagename=`grep AC_INIT $configure \
             | awk -F , -- "{print \\$1}" \
             | sed "s/AC_INIT([[]//" \
             | sed "s/[]]//"`

# Status 

status=`grep status $configure \
        | sed "s/^status=\(.*\)/\1/"`

# The name of the distribution

name="${packagename}-${version}-${rev}"

rm $configure

###########################

# Generate Nix expressions

cat > ${packagename}-dist.nix <<EOF
import ./${name}.nix
EOF

cat > ${name}.nix <<EOF
(import ./${packagename}-source-dist.nix) {
  name        = "${name}";
  packagename = "${packagename}";
  version     = "${version}";
  rev         = "${rev}"; 
  url         = "${url}";
}
EOF

