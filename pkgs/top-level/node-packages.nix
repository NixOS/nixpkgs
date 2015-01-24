{
  stdenv, pkgs, nodejs

  # Self-reference
, self

  # Needed natives for installation
, neededNatives ? [pkgs.python] ++ stdenv.lib.optionals stdenv.isLinux [ pkgs.utillinux ]

  # Attribute set of generated packages
, generated ? pkgs.callPackage ./node-packages-generated.nix { inherit self; }

  # Attribute set of overrides
, overrides ? {}
, ...
} @ args:

with stdenv.lib;

rec {
  overrides = {
    phantomjs.buildInputs = [ pkgs.phantomjs ];
    "node-expat".buildInputs = [ pkgs.expat ];
    "node-stringprep".buildInputs = [ pkgs.icu pkgs.which ];
    "node-protobuf".buildInputs = [ pkgs.protobuf ];
    "rbytes".buildInputs = [ pkgs.openssl ];
  } // args.overrides or {};

  # Apply overrides and back compatiblity transformations
  buildNodePackage = {...} @ args:
  let
    pkg = makeOverridable (
      pkgs.callPackage ../development/web/nodejs/build-node-package.nix {
        inherit nodejs neededNatives;
      }
    ) (args // {
      # Backwards compatibility
      src = if isList args.src then head args.src else args.src;
      pkgName = (builtins.parseDrvName args.name).name;
    });

    override = overrides.${args.name} or overrides.${pkg.pkgName} or {};

  in pkg.override override;

  # Backwards compatibility
  patchSource = fn: srcAttrs: fn srcAttrs;
  patchLatest = patchSource pkgs.fetchurl;

  /* Put manual packages below here (ideally eventually managed by npm2nix */
} // (
  if isAttrs generated then generated

  # Backwards compatiblity
  else pkgs.callPackage generated { inherit self; }
)
