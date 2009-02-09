let 

  trivial = import ./trivial.nix;
  lists = import ./lists.nix;
  strings = import ./strings.nix;
  attrsets = import ./attrsets.nix;
  sources = import ./sources.nix;
  options = import ./options.nix;
  debug = import ./debug.nix;
  misc = import ./misc.nix;

in
  { inherit trivial lists strings attrsets sources options debug; }
  # !!! don't include everything at top-level; perhaps only the most
  # commonly used functions.
  // trivial // lists // strings // attrsets // sources // options
  // debug // misc
