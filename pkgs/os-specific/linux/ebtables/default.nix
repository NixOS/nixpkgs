{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "ebtables-${version}";
  version = "2.0.10-4";

  src = fetchurl {
    url = "mirror://sourceforge/ebtables/ebtables-v${version}.tar.gz";
    sha256 = "0pa5ljlk970yfyhpf3iqwfpbc30j8mgn90fapw9cfz909x47nvyw";
  };

  makeFlags =
    [ "LIBDIR=$(out)/lib" "BINDIR=$(out)/sbin" "MANDIR=$(out)/share/man"
      "ETCDIR=$(out)/etc" "INITDIR=$(TMPDIR)" "SYSCONFIGDIR=$(out)/etc/sysconfig"
      "LOCALSTATEDIR=/var"
    ];

  preBuild =
    ''
      substituteInPlace Makefile --replace '-o root -g root' ""
    '';

  NIX_CFLAGS_COMPILE = "-Wno-error";

  preInstall = "mkdir -p $out/etc/sysconfig";

  meta = with stdenv.lib; {
    description = "A filtering tool for Linux-based bridging firewalls";
    homepage = http://ebtables.sourceforge.net/;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
