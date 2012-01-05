{ stdenv, fetchurl, substituteAll, libpcap }:

stdenv.mkDerivation rec {
  version = "2.4.5";
  name = "ppp-${version}";

  src = fetchurl {
    url = "${meta.homepage}ftp/ppp/${name}.tar.gz";
    sha256 = "019m00q85nrgdpjlhb9021a3iw3pr4a0913gp4h9k7r9r7z7lca3";
  };

  patches =
    [ ( substituteAll {
        src = ./nix-purity.patch;
        inherit libpcap;
        glibc = stdenv.gcc.libc;
      })
      ./nonpriv.patch
    ];

  postPatch = "rm -v include/linux/if_pppol2tp.h";

  buildInputs = [ libpcap ];

  postInstall = "chmod -v -R +rw $out";

  meta = {
    homepage = http://ppp.samba.org/;
    description = "Point-to-point implementation for Linux and Solaris";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
