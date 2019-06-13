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
    src = pkgs.fetchFromGitHub {
      owner = "Moeditor";
      repo = "js-sequence-diagrams";
      rev = "4d46bc6229a3f93c9bcad561cab4924034f5456d";
      sha256 = "09ri5cx5yq87p3nla06gs0xb2gifmsy0xhs0s5524xr4ya6pnivv";
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
