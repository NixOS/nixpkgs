{ stdenv, fetchurl, coffeescript }:

let version = "0.1"; in

stdenv.mkDerivation rec {
  name = "npm2nix-${version}";

  src = fetchurl {
    url = "https://bitbucket.org/shlevy/npm2nix/get/${version}.tar.bz2";
    sha256 = "14rfs114k02yc9gx0bcjqy67f9cqgkrr1dccwlzl09q9b6qs1k3k";
  };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    sed 's|#!/usr/bin/env coffee|#!${coffeescript}/bin/coffee|' npm2nix.coffee \
      > $out/bin/npm2nix
    chmod +x $out/bin/npm2nix
  '';

  meta = {
    description = "A tool to generate nix expressions from npm packages";
    maintainer = stdenv.lib.maintainers.shlevy;
  };
}
