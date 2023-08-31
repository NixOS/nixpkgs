{ system, name, ver, url, sha256, configureArgs ? [], executable ? false, patches ? [], make ? "make" } :

let fetchURL = import <nix/fetchurl.nix>;

in derivation {
  inherit system configureArgs make;
  name = "trivial-bootstrap-${name}-${ver}";
  dname = "${name}-${ver}";
  src = fetchURL {
    inherit url sha256 executable;
  };
  builder = ./trivial-builder.sh;
  patches = builtins.map (patch: if (builtins.isPath patch) then patch else fetchURL ({ executable = false; } // patch)) patches;
}
