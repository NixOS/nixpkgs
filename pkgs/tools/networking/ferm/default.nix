{ stdenv, fetchurl, makeWrapper, perl, ebtables, ipset, iptables, nixosTests }:

let
  inherit (stdenv.lib.versions) majorMinor;
in stdenv.mkDerivation rec {
  version = "2.5";
  pname = "ferm";

  src = fetchurl {
    url = "http://ferm.foo-projects.org/download/${majorMinor version}/ferm-${version}.tar.xz";
    sha256 = "0lxqcpirphihpvdqrh5kq0621aqq0h2vdy9q2v85gqdhd52js20p";
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

  passthru.tests.ferm = nixosTests.ferm;

  meta = {
    homepage = "http://ferm.foo-projects.org/";
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
