{fetchFromGitHub, callPackage, stdenv, nodejs, fetchurl, fetchgit, utillinux, python, icu }:
with stdenv.lib;
let
  nodePackages = callPackage (import ../../top-level/node-packages.nix) {
    inherit stdenv nodejs fetchurl fetchgit;
    neededNatives = [ python icu ] ++ optional stdenv.isLinux utillinux;
    self = nodePackages;
    generated = ./package.nix;
  };
in nodePackages.buildNodePackage rec {
  name = "matrix-appservice-irc-${version}";
  version = "0.3.1";
  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "matrix-appservice-irc";
    rev = "${version}";
    sha256 = "157g64rn8fsr471wswhwv058amm0nx1qclcl3afk2rlrwwa91dwb";
  };
  bin = true;
  buildInputs = nodePackages.nativeDeps."matrix-appservice-irc" or [];
  deps = [ nodePackages.by-spec."bluebird"."^3.1.1" nodePackages.by-spec."crc"."^3.2.1" nodePackages.by-spec."extend"."^2.0.0" nodePackages.by-spec."fs"."0.0.2" nodePackages.by-spec."irc"."matrix-org/node-irc#45d7ca190477bd545817e8152f2e626c9166cf6b" nodePackages.by-spec."jayschema"."^0.3.1" nodePackages.by-spec."js-yaml"."^3.2.7" nodePackages.by-spec."matrix-appservice-bridge"."^1.0.1" nodePackages.by-spec."nedb"."^1.1.2" nodePackages.by-spec."nopt"."^3.0.1" nodePackages.by-spec."request"."^2.54.0" nodePackages.by-spec."sanitize-html"."^1.6.1" nodePackages.by-spec."winston"."^0.9.0" ];
  peerDependencies = [];

  meta = with stdenv.lib; {
    homepage = https://github.com/matrix-org/matrix-appservice-irc;
    license = with licenses; [ asl20 ];
    description = "Node.js IRC bridge for Matrix";
    platforms = platforms.all;
    maintainers = [ maintainers.ralith ];
  };
}
