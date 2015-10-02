{ stdenv, fetchurl, openssl, libpcap, python, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "vde2-2.3.2";

  src = fetchurl {
    url = "mirror://sourceforge/vde/vde2/2.3.1/${name}.tar.gz";
    sha256 = "14xga0ib6p1wrv3hkl4sa89yzjxv7f1vfqaxsch87j6scdm59pr2";
  };

  buildInputs = [ openssl libpcap python autoreconfHook ];

  # Fixes:
  # Cannot resolve ctl dir path '...': Value too large for defined data type
  # Do not apply to vdetaplib

  postPatch = ''
    for f in $(find . -name Makefile.am); do
      if echo $f|grep -q vdetaplib; then
        continue
      fi

      sed \
        -e 's/AM_CPPFLAGS =/AM_CPPFLAGS = -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE/' \
        -e 's/AM_CFLAGS =/AM_CFLAGS = -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE/' \
        -i $f
    done
  '';

  meta = {
    homepage = http://vde.sourceforge.net/;
    description = "Virtual Distributed Ethernet, an Ethernet compliant virtual network";
  };
}
