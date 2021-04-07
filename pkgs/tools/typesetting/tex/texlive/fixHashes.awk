#!/usr/bin/env nix-shell
#! nix-shell -i "gawk -f" -p gawk

BEGIN {
  print "{"
}

/-texlive-/ && !/\.bin/ {
  if (match($0, /-texlive-([^\/]*)/, m) == 0) {
    print "No match for \""$0"\"" > "/dev/stderr"
    exit 1
  }
  cmd="nix-hash --type sha1 --base32 "$0
  if (( cmd | getline hash ) <= 0) {
    print "Error executing nix-hash" > "/dev/stderr"
    exit 1
  }
  close(cmd)
  printf("\"%s\"=\"%s\";\n", m[1], hash)
}

END {
  print "}"
}
