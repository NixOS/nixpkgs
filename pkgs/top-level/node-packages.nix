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

let
  removeDeps = remove: deps: filterAttrs (n: d: all (r: r != d.pkgName) remove) deps;
  replaceDep = replace: deps: mapAttrs (n: d: if d.pkgName == replace.pkgName then replace else d) deps;
in rec {
  overrides = {
    phantomjs.buildInputs = [ pkgs.phantomjs ];
    "node-expat".buildInputs = [ pkgs.expat ];
    "node-stringprep".buildInputs = [ pkgs.icu pkgs.which ];
    "node-protobuf".buildInputs = [ pkgs.protobuf ];

    "tap-0.3.3".patchPhase = ''
      substituteInPlace package.json --replace '"tap-consumer",' ""
    '';
    "node-uptime" = (p: {
      # Net-ping is not really used
      patchPhase = ''
        ${self.json}/bin/json -I -f package.json -e 'delete this.dependencies["net-ping"]'
      '';
      deps = removeDeps ["net-ping"] p.deps;
    });
    bipio = (p: {
      patchPhase = ''
        substituteInPlace src/bootstrap.js --replace "memwatch = require('memwatch')," ""
        substituteInPlace tools/setup.js --replace "__dirname + '/../'" "'.'"
        ${self.json}/bin/json -I -f package.json -e 'this.scripts.install=""'
        ${self.json}/bin/json -I -f package.json -e 'delete this.dependencies.sleep'
        ${self.json}/bin/json -I -f package.json -e 'delete this.dependencies.memwatch'
        ${self.json}/bin/json -I -f package.json -e 'delete this.dependencies["webkit-devtools-agent"]'
      '';
      deps = replaceDep self.sleep (removeDeps ["memwatch" "webkit-devtools-agent"] p.deps);
    });
    bip-pod.patchPhase = ''
      substituteInPlace index.js --replace \
        "__dirname + (literal ? '/' : '/../bip-pod-') + podName" \
        "(literal ? __dirname + '/' : \"bip-pod-\") + podName"
    '';
    webdrvr.preBuild = ''
      mkdir ../webdrvr
      ln -s ${pkgs.fetchurl {
        url = "https://selenium-release.storage.googleapis.com/2.43/selenium-server-standalone-2.43.1.jar";
        sha1 = "ef1b5f8ae9c99332f99ba8794988a1d5b974d27b";
      }} ../webdrvr/selenium-server-standalone-2.43.1.jar
      ln -s ${pkgs.fetchurl {
        url = "http://chromedriver.storage.googleapis.com/2.10/chromedriver_linux64.zip";
        sha1 = "26220f7e43ee3c0d714860db61c4d0ecc9bb3d89";
      }} ../webdrvr/chromedriver_linux64.zip
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
