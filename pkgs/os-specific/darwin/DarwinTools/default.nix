{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "DarwinTools-1";

  src = fetchurl {
    url = "https://opensource.apple.com/tarballs/DarwinTools/${name}.tar.gz";
    sha256 = "0hh4jl590jv3v830p77r3jcrnpndy7p2b8ajai3ldpnx2913jfhp";
  };

  patches = [
    ./sw_vers-CFPriv.patch
  ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace gcc cc
  '';

  configurePhase = ''
    export SRCROOT=.
    export SYMROOT=.
    export DSTROOT=$out
  '';

  postInstall = ''
    mv $out/usr/* $out
    rmdir $out/usr
  '';

  meta = {
    maintainers = [ lib.maintainers.matthewbauer ];
    platforms = lib.platforms.darwin;
  };
}
