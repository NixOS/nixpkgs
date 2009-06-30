let 

  trivial = import ./trivial.nix;
  lists = import ./lists.nix;
  strings = import ./strings.nix;
  stringsWithDeps = import ./strings-with-deps.nix;
  attrsets = import ./attrsets.nix;
  sources = import ./sources.nix;
  options = import ./options.nix;
  types = import ./types.nix;
  meta = import ./meta.nix;
  debug = import ./debug.nix;
  misc = import ./misc.nix;

in
  { inherit trivial lists strings stringsWithDeps attrsets sources options types meta debug; }
  # !!! don't include everything at top-level; perhaps only the most
  # commonly used functions.
  // trivial // lists // strings // stringsWithDeps // attrsets // sources
  // options // types // meta // debug // misc
