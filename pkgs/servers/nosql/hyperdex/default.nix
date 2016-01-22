{ stdenv, fetchurl, makeWrapper, unzip, autoreconfHook, autoconf-archive
, python, libsodium, pkgconfig, popt, glog, xz, json_c, gperf, yacc
, flex, pandoc, help2man, callPackage }:

assert stdenv.isLinux;

let
hyperleveldb = callPackage ./hyperleveldb.nix {};
libpo6 = callPackage ./libpo6.nix {};
libe = callPackage ./libe.nix { inherit libpo6; };
busybee = callPackage ./busybee.nix { inherit libpo6 libe; };
replicant = callPackage ./replicant.nix {
  inherit libpo6 libe busybee hyperleveldb;
};
libmacaroons = callPackage ./libmacaroons.nix { };

in
stdenv.mkDerivation rec {
  name = "hyperdex-${version}";
  version = "1.5.0";

  src = fetchurl {
    url = "https://github.com/rescrv/HyperDex/archive/releases/${version}.zip";
    sha256 = "0l7w3x6c4nslz5ijmj8xys0k1slwi3s4crxmi16ml1x32bqgzhj7";
  };

  buildInputs = [
    autoreconfHook
    autoconf-archive
    busybee
    glog
    hyperleveldb
    json_c
    libe
    libmacaroons
    libpo6
    pkgconfig
    popt
    python
    replicant
    unzip
    gperf
    yacc
    flex
    help2man
    pandoc
  ];

  meta = with stdenv.lib; {
    description = "A scalable, searchable key-value store";
    homepage = http://hyperdex.org;
    license = licenses.bsd3;
  };
}
