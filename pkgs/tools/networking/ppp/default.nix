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
      (fetchurl {
        name = "CVE-2015-3310.patch";
        url = "https://anonscm.debian.org/git/collab-maint/pkg-ppp.git/plain/debian/patches/rc_mksid-no-buffer-overflow?h=debian/2.4.7-1%2b4";
        sha256 = "1dk00j7bg9nfgskw39fagnwv1xgsmyv0xnkd6n1v5gy0psw0lvqh";
      })
      ./musl-fix-headers.patch
    ];

  buildInputs = [ libpcap ];

  installPhase = ''
    mkdir -p $out/bin
    make install
    install -D -m 755 scripts/{pon,poff,plog} $out/bin
  '';

  postFixup = ''
    for tgt in pon poff plog; do
      substituteInPlace "$out/bin/$tgt" --replace "/usr/sbin" "$out/bin"
    done
  '';

  meta = {
    homepage = https://ppp.samba.org/;
    description = "Point-to-point implementation for Linux and Solaris";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.falsifian ];
  };
}
