# NOTE: This file must *be* an attrset; not a function. Otherwise, it will not be
#       memoized by the Nix evaluator. In other words, these package sets will
#       be re-evaluated unnecessarily, potentially many times, because code that
#       uses this (i.e. pkgsPlain) does not care about this reuse, by design.
let
  lib = import ../../lib;
in
lib.genAttrs lib.platforms.all (
  system:
  import ./default.nix {
    localSystem = system;
  }
)
