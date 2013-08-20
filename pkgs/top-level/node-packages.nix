{ pkgs, stdenv, nodejs, fetchurl, neededNatives, self }:

let
  inherit (self) buildNodePackage patchLatest;

  importGeneratedPackages = generated: nativeDeps: self:
    let
      nativeDepsList = { name, spec }:
        let
          nameOr = if builtins.hasAttr name nativeDeps
            then builtins.getAttr name nativeDeps
            else {};
          depsOr = if builtins.hasAttr spec nameOr
            then builtins.getAttr spec nameOr
            else [];
        in depsOr;
      full = pkgs.lib.mapAttrs (name: specs: pkgs.lib.mapAttrs (spec: pkg:
        pkgs.lib.makeOverridable buildNodePackage {
          name = "${name}-${pkg.version}";
          src = (if pkg.patchLatest then patchLatest else fetchurl) {
            url = pkg.tarball;
            sha1 = pkg.sha1 or "";
            sha256 = pkg.sha256 or "";
          };
          deps = map (dep: builtins.getAttr dep.spec (builtins.getAttr dep.name self.full)) pkg.dependencies;
          peerDeps  = map (dep: builtins.getAttr dep.spec (builtins.getAttr dep.name self.full)) pkg.peerDependencies;
          buildInputs = nativeDepsList { inherit name spec; };
        }
      ) specs) (removeAttrs generated [ "#topLevel" ]);
      topLevel = pkgs.lib.mapAttrs (name: spec:
        builtins.getAttr spec (builtins.getAttr name self.full)
      ) generated."#topLevel" or {};
    in topLevel // { inherit full; };
in {
  inherit importGeneratedPackages;

  nativeDeps = {
    "node-expat"."*" = [ pkgs.expat ];
    "rbytes"."0.0.2" = [ pkgs.openssl ];
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
