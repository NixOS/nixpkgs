{ system, name, ver, url, sha256, configureArgs ? [], executable ? false, patches ? [] } :

let fetchURL = import <nix/fetchurl.nix>;

in derivation {
  inherit system configureArgs;
  name = "trivial-bootstrap-${name}-${ver}";
  dname = "${name}-${ver}";
  src = fetchURL {
    inherit url sha256 executable;
  };
  builder = ./trivial-builder.sh;
  patches = builtins.map (patch: fetchURL ({ executable = false; } // patch)) patches;
}
