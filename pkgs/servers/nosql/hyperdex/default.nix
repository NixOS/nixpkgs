{ stdenv, fetchurl, makeWrapper, unzip, autoconf, automake, libtool,
  python, sodium, pkgconfig, popt, glog, xz, json_c, gperf, yacc,
  flex, haskellPackages, help2man, autoconf-archive, callPackage }:

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
    sha256 = "0s1capy2hj45f5rmdb4fk0wxy7vz69krplhba57f6wrkpcz1zb57";
  };

  buildInputs = [
    autoconf
    autoconf-archive
    automake
    busybee
    glog
    hyperleveldb
    json_c
    libe
    libmacaroons
    libpo6
    libtool
    pkgconfig
    popt
    python
    replicant
    unzip
    gperf
    yacc
    flex
    help2man
    haskellPackages.pandoc
  ];
  preConfigure = "autoreconf -fi";

  meta = with stdenv.lib; {
    description = "HyperDex is a scalable, searchable key-value store";
    homepage = http://hyperdex.org;
    license = licenses.bsd3;
  };
}
