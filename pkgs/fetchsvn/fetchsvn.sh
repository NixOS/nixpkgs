#! /bin/sh

echo "exporting svn repository $url (at rev $rev) into $out..."

$svn/bin/svn export -r $rev $url $out || exit 1
