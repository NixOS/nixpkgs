{ stdenv, fetchurl, zlib }:

stdenv.mkDerivation rec {
  name = "mandoc-${version}";
  version = "1.14.3";

  src = fetchurl {
    url = "http://mdocml.bsd.lv/snapshots/${name}.tar.gz";
    sha256 = "0a4mv4pk6939v544dbfjvxwvi13r6c66i45nskm6j5ccjmkqy30b";
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
