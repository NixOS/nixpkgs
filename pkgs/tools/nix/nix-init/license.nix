# vendored from src/licenses.nix

{ lib, writeText }:

let
  inherit (builtins) concatLists concatStringsSep length;
  inherit (lib) flip licenses mapAttrsToList optional;

  inserts = concatLists
    (flip mapAttrsToList licenses
      (k: v: optional (v ? spdxId) ''  xs.insert("${v.spdxId}", "${k}");''));
in

writeText "license.rs" ''
  fn get_nix_licenses() -> rustc_hash::FxHashMap<&'static str, &'static str> {
      let mut xs = std::collections::HashMap::with_capacity_and_hasher(
          ${toString (length inserts)},
          Default::default(),
      );
      ${concatStringsSep "\n    " inserts}
      xs
  }
''
