#! /bin/sh

set -e

echo "exporting svn repository $url/$dir (at rev $rev) into $out..."

svn export -r $rev $url/$dir $dir

# touch bootstrapped sources because subversion doesn't sets the mtime of files
# to checkout time, not to the last mtime in the repository.
MTIME=`date +%Y%m%d%H%M.%S`
echo "** INFO -- Modification time: $MTIME"
find $dir -print | xargs touch -t $MTIME
# end of touch

mkdir $out
tar zcf $out/$dir.tar.gz $dir
