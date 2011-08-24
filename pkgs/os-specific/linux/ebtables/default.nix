{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "ebtables-2.0.9-2";

  src = fetchurl {
    url = mirror://sourceforge/ebtables/ebtables-v2.0.9-2.tar.gz;
    sha256 = "18yni9zzhfi1ygkgifzj8qpn95cwwiw7j6b3wsl1bij39mj5z1cq";
  };

  makeFlags =
    "LIBDIR=$(out)/lib BINDIR=$(out)/sbin MANDIR=$(out)/share/man " +
    "ETCDIR=$(out)/etc INITDIR=$(TMPDIR) SYSCONFIGDIR=$(out)/etc/sysconfig";

  preBuild =
    ''
      substituteInPlace Makefile --replace '-o root -g root' ""
    '';

  preInstall = "mkdir -p $out/etc/sysconfig";

  meta = {
    description = "A filtering tool for Linux-based bridging firewalls";
    homepage = http://ebtables.sourceforge.net/;
    platforms = stdenv.lib.platforms.linux;
  };
}
