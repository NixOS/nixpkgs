#! /bin/sh

echo "exporting svn repository $url (at rev $rev) into $out..."

svn export -r $rev $url $out || exit 1

