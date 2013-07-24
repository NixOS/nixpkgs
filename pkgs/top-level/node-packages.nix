{ pkgs, stdenv, nodejs, fetchurl, neededNatives, self }:

let
  inherit (self) buildNodePackage patchLatest;

  importGeneratedPackages = generated: nativeDeps: self:
    let
      all = pkgs.lib.fold (pkg: { top-level, full }: {
        top-level = top-level ++ pkgs.lib.optional pkg.topLevel {
          name = pkg.name;
          value = builtins.getAttr pkg.spec (builtins.getAttr pkg.name self.full);
        };
        full = full // builtins.listToAttrs [ {
          inherit (pkg) name;
          value = (if builtins.hasAttr pkg.name full
            then builtins.getAttr pkg.name full
            else {}
          ) // builtins.listToAttrs [ {
            name = pkg.spec;
            value = pkgs.lib.makeOverridable buildNodePackage {
              name = "${pkg.name}-${pkg.version}";
              src = (if pkg.patchLatest then patchLatest else fetchurl) {
                url = pkg.tarball;
                sha1 = pkg.sha1 or "";
                sha256 = pkg.sha256 or "";
              };
              deps = map (dep: builtins.getAttr dep.spec (builtins.getAttr dep.name self.full)) pkg.dependencies;
            };
          } ];
        } ];
      } ) { top-level = []; full = {}; } generated;
    in builtins.listToAttrs all.top-level // { inherit (all) full; };
in {
  inherit importGeneratedPackages;

  nativeDeps = {
    "node-expat-*" = [ pkgs.expat ];
    "rbytes-0.0.2" = [ pkgs.openssl ];
  };

  buildNodePackage = import ../development/web/nodejs/build-node-package.nix {
    inherit stdenv nodejs neededNatives;
    inherit (pkgs) runCommand;
  };

  patchLatest = srcAttrs:
    let src = fetchurl srcAttrs; in pkgs.runCommand src.name {} ''
      mkdir unpack
      cd unpack
      tar xf ${src}
      mv */ package 2>/dev/null || true
      sed -i -e "s/: \"latest\"/: \"*\"/" package/package.json
      tar cf $out *
    '';

  /* Put manual packages below here (ideally eventually managed by npm2nix */
} // importGeneratedPackages (import ./node-packages-generated.nix) self.nativeDeps self
