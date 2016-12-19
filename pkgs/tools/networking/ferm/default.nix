{ stdenv, fetchurl, makeWrapper, perl, ebtables, ipset, iptables }:

stdenv.mkDerivation rec {
  version = "2.3";
  name = "ferm-${version}";

  src = fetchurl {
    url = "http://ferm.foo-projects.org/download/${version}/ferm-${version}.tar.gz";
    sha256 = "0jx63fhjw5y1ahgdbn4hgd7sq6clxl80dr8a2hkryibfbwz3vs4x";
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
