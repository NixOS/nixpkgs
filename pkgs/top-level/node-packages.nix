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

    # Remove fsevents dependency because it is OSX-specific.
    "chokidar".deps = {
      "anymatch-1.1.0" = self.by-version."anymatch"."1.1.0";
      "async-each-0.1.6" = self.by-version."async-each"."0.1.6";
      "glob-parent-1.0.0" = self.by-version."glob-parent"."1.0.0";
      "is-binary-path-1.0.0" = self.by-version."is-binary-path"."1.0.0";
      "readdirp-1.3.0" = self.by-version."readdirp"."1.3.0";
    };

    bipio.patchPhase = ''
      ${self.json}/bin/json -I -f package.json -e 'this.scripts.install=""'
    '';
    bip-pod.patchPhase = ''
      substituteInPlace index.js --replace \
        "__dirname + (literal ? '/' : '/../bip-pod-') + podName" \
        "(literal ? __dirname + '/' : \"bip-pod-\") + podName"
    '';
  } // args.overrides or {};

  # Apply overrides and back compatiblity transformations
  buildNodePackage = {...} @ args:
  let
    pkg = makeOverridable (
      pkgs.callPackage ../development/web/nodejs/build-node-package.nix {
        inherit nodejs neededNatives;
      }
    ) (args // (optionalAttrs (isList args.src) {
      # Backwards compatibility
      src = head args.src;
    }) // (optionalAttrs (attrByPath ["passthru" "names"] null args != null) {
       pkgName = head args.passthru.names;
    }));

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
