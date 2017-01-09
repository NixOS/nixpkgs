{ stdenv, fetchurl, makeWrapper, perl, ebtables, ipset, iptables }:

stdenv.mkDerivation rec {
  version = "2.3.1";
  name = "ferm-${version}";

  src = fetchurl {
    url = "http://ferm.foo-projects.org/download/2.3/ferm-${version}.tar.gz";
    sha256 = "1scdnd2jk4787jyr6fxav2598g0x7hjic5b8bj77j8s0hki48m4a";
  };

  buildInputs = [ perl ipset ebtables iptables makeWrapper ];
  preConfigure = ''
    substituteInPlace config.mk --replace "PERL = /usr/bin/perl" "PERL = ${perl}/bin/perl"
    substituteInPlace config.mk --replace "PREFIX = /usr" "PREFIX = $out"
  '';
  postInstall = ''
    rm -r $out/lib/systemd
    for i in "$out/sbin/"*; do
      wrapProgram "$i" --prefix PATH : "${iptables}/bin:${ipset}/bin:${ebtables}/bin"
    done
  '';

  meta = {
    homepage = http://ferm.foo-projects.org/;
    description = "Tool to maintain complex firewalls";
    longDescription = ''
      ferm is a tool to maintain complex firewalls, without having the trouble to
      rewrite the complex rules over and over again. ferm allows the entire
      firewall rule set to be stored in a separate file, and to be loaded with one
      command. The firewall configuration resembles structured programming-like
      language, which can contain levels and lists.
    '';
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [mic92];
    platforms = stdenv.lib.platforms.linux;
  };
}
