#! /bin/sh -v

# Build the distribution

echo "building revision $rev of $url"

if ! storeexprs=($(nix-instantiate -vvvv do-it.nix)); then exit 1; fi

srcexpr=${storeexprs[0]}
#testexpr=${storeexprs[1]}

if ! nix-store -vvvv -r "$srcexpr" > /dev/null; then exit 1; fi

if ! outpath=$(nix-store -qn "$srcexpr"); then exit 1; fi

#uploader="http://losser.st-lab.cs.uu.nl/~eelco/cgi-bin/upload.pl/"

#curl --silent -T "$outpath/manual.html" "$uploader" || exit 1
#curl --silent -T "$outpath/style.css" "$uploader" || exit 1
#curl --silent -T "$outpath"/nix-*.tar.bz2 "$uploader" || exit 1

#if ! nix-store -vvvv -r "$testexpr" > /dev/null; then exit 1; fi
