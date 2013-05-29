{ pkgs, stdenv, nodejs, fetchurl, neededNatives }:

let
  inherit (self) buildNodePackage patchLatest;

  importGeneratedPackages = generated: nativeDeps: self: builtins.listToAttrs (pkgs.lib.fold (pkg: pairs:
    (pkgs.lib.optional pkg.topLevel { name = pkg.baseName; value = builtins.getAttr pkg.fullName self; }) ++ [
      {
        name = pkg.fullName;
        value = buildNodePackage rec {
          name = "${pkg.baseName}-${pkg.version}";
          src = (if pkg.patchLatest then patchLatest else fetchurl) {
            url = "http://registry.npmjs.org/${pkg.baseName}/-/${name}.tgz";
            sha256 = pkg.hash;
          };
          deps = map (dep: builtins.getAttr "${dep.name}-${dep.range}" self) pkg.dependencies;
          buildInputs = if builtins.hasAttr name nativeDeps then builtins.getAttr name nativeDeps else [];
        };
      }
    ] ++ pairs
  ) [] generated);

  self = {
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
  } // importGeneratedPackages (import ./node-packages-generated.nix) self.nativeDeps self;
in self
