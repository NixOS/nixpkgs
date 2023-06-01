{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "DarwinTools";
  version = "1";

  src = fetchurl {
    url = "https://web.archive.org/web/20180408044816/https://opensource.apple.com/tarballs/DarwinTools/DarwinTools-${version}.tar.gz";
    hash = "sha256-Fzo5QhLd3kZHVFKhJe7xzV6bmRz5nAsG2mNLkAqVBEI=";
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
