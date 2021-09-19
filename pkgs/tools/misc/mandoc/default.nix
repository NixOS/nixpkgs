{ lib, stdenv, fetchurl, zlib }:

stdenv.mkDerivation rec {
  pname = "mandoc";
  version = "1.14.6";

  src = fetchurl {
    url = "https://mandoc.bsd.lv/snapshots/mandoc-${version}.tar.gz";
    sha256 = "8bf0d570f01e70a6e124884088870cbed7537f36328d512909eb10cd53179d9c";
  };

  buildInputs = [ zlib ];

  configureLocal = ''
    HAVE_WCHAR=1
    MANPATH_DEFAULT="/run/current-system/sw/share/man"
    OSNAME="NixOS"
    PREFIX="$out"
    LD_OHASH="-lutil"
    CC=${stdenv.cc.targetPrefix}cc
  '';

  preConfigure = ''
    printf '%s' "$configureLocal" > configure.local
  '';

  meta = with lib; {
    homepage = "https://mandoc.bsd.lv/";
    description = "suite of tools compiling mdoc and man";
    downloadPage = "http://mandoc.bsd.lv/snapshots/";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ bb010g ramkromberg sternenseemann ];
  };
}
