{ stdenv, fetchurl, substituteAll, libpcap }:

stdenv.mkDerivation rec {
  version = "2.4.7";
  name = "ppp-${version}";

  src = fetchurl {
    url = "mirror://samba/ppp/${name}.tar.gz";
    sha256 = "0c7vrjxl52pdwi4ckrvfjr08b31lfpgwf3pp0cqy76a77vfs7q02";
  };

  patches =
    [ ( substituteAll {
        src = ./nix-purity.patch;
        inherit libpcap;
        glibc = stdenv.cc.libc;
      })
      # Without nonpriv.patch, pppd --version doesn't work when not run as
      # root.
      ./nonpriv.patch
    ];

  buildInputs = [ libpcap ];

  meta = {
    homepage = https://ppp.samba.org/;
    description = "Point-to-point implementation for Linux and Solaris";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.falsifian ];
  };
}
