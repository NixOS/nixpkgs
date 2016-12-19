{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name  = "${pname}-${date}";
  pname = "pwnat";
  date  = "2014-09-08";

  src = fetchFromGitHub {
    owner  = "samyk";
    repo   = pname;
    rev    = "1d07c2eb53171733831c0cd01e4e96a3204ec446";
    sha256 = "056xhlnf1axa6k90i018xwijkwc9zc7fms35hrkzwgs40g9ybrx5";
  };

  installPhase = ''
    mkdir -p $out/bin $out/share/pwnat
    cp pwnat $out/bin
    cp README* COPYING* $out/share/pwnat
  '';

  meta = with stdenv.lib; {
    homepage    = http://samy.pl/pwnat/;
    description = "ICMP NAT to NAT client-server communication";
    license     = stdenv.lib.licenses.gpl3Plus;
    maintainers = with maintainers; [viric];
    platforms   = with platforms; linux;
  };
}
