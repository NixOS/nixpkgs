{stdenv, fetchFromGitHub, pkgconfig, ncurses, libnl }:

stdenv.mkDerivation rec {
  name = "horst-${version}";
  version = "git-2015-07-22";

  src = fetchFromGitHub {
    owner = "br101";
    repo = "horst";
    rev = "b62fc20b98690061522a431cb278d989e21141d8";
    sha256 = "176yma8v2bsab2ypgmgzvjg0bsbnk9sga3xpwkx33mwm6q79kd6g";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ ncurses libnl ];

  installPhase = ''
    mkdir -p $out/bin
    mv horst $out/bin

    mkdir -p $out/man/man1
    cp horst.1 $out/man/man1
  '';

  meta = with stdenv.lib; {
    description = "Small and lightweight IEEE802.11 wireless LAN analyzer with a text interface";
    homepage = http://br1.einfach.org/tech/horst/;
    maintainers = [ maintainers.fpletz ];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
