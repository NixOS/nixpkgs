#! /bin/sh -e

echo 1>&2 "Test: Merge of option bindings."
nix-instantiate merge.nix --eval-only --strict --xml >& merge.out
diff merge.ref merge.out

echo 1>&2 "Test: Filter of option declarations."
nix-instantiate keep.nix --eval-only --strict --xml >& keep.out
diff keep.ref keep.out
