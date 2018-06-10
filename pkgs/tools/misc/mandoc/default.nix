{ stdenv, fetchurl, zlib }:

stdenv.mkDerivation rec {
  name = "mandoc-${version}";
  version = "1.13.4";

  src = fetchurl {
    url = "http://mdocml.bsd.lv/snapshots/mdocml-${version}.tar.gz";
    sha256 = "1vz0g5nvjbz1ckrg9cn6ivlnb13bcl1r6nc4yzb7300qvfnw2m8a";
  };

  buildInputs = [ zlib ];

  configureLocal = ''
    HAVE_WCHAR=1
    MANPATH_DEFAULT="/run/current-system/sw/share/man"
    OSNAME="NixOS"
    PREFIX="$out"
    HAVE_MANPATH=1
    LD_OHASH="-lutil"
    BUILD_DB=0
  '';

  preConfigure = ''
    echo $configureLocal > configure.local
  '';

  meta = with stdenv.lib; {
    homepage = http://mdocml.bsd.lv/;
    description = "suite of tools compiling mdoc and man";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ ramkromberg ];
  };
}
