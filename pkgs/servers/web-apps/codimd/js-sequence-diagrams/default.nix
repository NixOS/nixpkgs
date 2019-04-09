{ pkgs, nodejs, extraNodePackages }:

let
  nodeEnv = import ../../../../development/node-packages/node-env.nix {
    inherit (pkgs) stdenv python2 utillinux runCommand writeTextFile;
    inherit nodejs;
    libtool = if pkgs.stdenv.isDarwin then pkgs.darwin.cctools else null;
  };
in
  nodeEnv.buildNodePackage {
    name = "js-sequence-diagrams";
    packageName = "js-sequence-diagrams";
    version = "1000000.0.6";
    src = pkgs.fetchurl {
      url = "https://registry.npmjs.org/js-sequence-diagrams/-/js-sequence-diagrams-1000000.0.6.tgz";
      sha1 = "e95db01420479c5ccbc12046af1da42fde649e5c";
    };
    dependencies = [ ];
    dontNpmInstall = true;
    meta = {
      description = "Fucks NPM and draws simple SVG sequence diagrams from textual representation of the diagram";
      homepage = "https://github.com/Moeditor/js-sequence-diagrams#readme";
      license = "BSD-2-Clause";
    };
    production = true;
    bypassCache = true;

    postInstall = builtins.concatStringsSep "\n" (pkgs.lib.mapAttrsToList (
      name: pkg: "ln -s ${pkg}/lib/node_modules/${name} $out/lib/node_modules/${name}"
    ) extraNodePackages);
  }
