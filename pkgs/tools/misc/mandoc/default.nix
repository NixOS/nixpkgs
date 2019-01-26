{ stdenv, fetchurl, zlib }:

stdenv.mkDerivation rec {
  name = "mandoc-${version}";
  version = "1.14.4";

  src = fetchurl {
    url = "https://mandoc.bsd.lv/snapshots/mandoc-${version}.tar.gz";
    sha256 = "24eb72103768987dcc63b53d27fdc085796330782f44b3b40c4660b1e1ee9b9c";
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
    CC=${stdenv.cc.targetPrefix}cc
  '';

  patches = [
    ./remove-broken-cc-check.patch
  ];

  preConfigure = ''
    echo $configureLocal > configure.local
  '';

  meta = with stdenv.lib; {
    homepage = https://mandoc.bsd.lv/;
    description = "suite of tools compiling mdoc and man";
    downloadPage = "http://mandoc.bsd.lv/snapshots/";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ bb010g ramkromberg ];
  };
}
