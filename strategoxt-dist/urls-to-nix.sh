#! /bin/sh

urls="https://svn.cs.uu.nl:12443/repos/StrategoXT/trunk/StrategoXT \
      https://svn.cs.uu.nl:12443/repos/StrategoXT/trunk/tiger"

for url in ${urls}
do
   echo ${url}
   ./svn-to-nix.sh ${url}
done