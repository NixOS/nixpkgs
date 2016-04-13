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
        glibc = stdenv.cc.libc.dev or stdenv.cc.libc;
      })
      # Without nonpriv.patch, pppd --version doesn't work when not run as
      # root.
      ./nonpriv.patch
    ];

  buildInputs = [ libpcap ];

  installPhase = ''
    mkdir -p $out/bin
    make install
    install -D -m 755 scripts/{pon,poff,plog} $out/bin
  '';

  postFixup = ''
    substituteInPlace $out/bin/{pon,poff,plog} --replace "/usr/sbin" "$out/bin"
  '';

  meta = {
    homepage = https://ppp.samba.org/;
    description = "Point-to-point implementation for Linux and Solaris";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.falsifian ];
  };
}
