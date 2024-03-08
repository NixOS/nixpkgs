self:
let
  versions = {
    postgresql_12 = ./12.nix;
    postgresql_13 = ./13.nix;
    postgresql_14 = ./14.nix;
    postgresql_15 = ./15.nix;
    postgresql_16 = ./16.nix;
  };

  mkAttributes = jitSupport:
    self.lib.mapAttrs' (version: path:
      let
        attrName = if jitSupport then "${version}_jit" else version;
      in
      self.lib.nameValuePair attrName (import path {
        inherit jitSupport self;
      })
      ) versions;

  withoutJIT = mkAttributes false;
  withJIT = mkAttributes true;

  # Always selects libpq as the latest postgresql version
  libpq = let
    vs = builtins.map (v: withoutJIT.${v}) (builtins.attrNames versions);
    latestFirst = builtins.sort (v1: v2: (builtins.compareVersions v1.version v2.version) > 0) vs;
  in
  builtins.head latestFirst;

in
withoutJIT // withJIT // { inherit libpq; }
