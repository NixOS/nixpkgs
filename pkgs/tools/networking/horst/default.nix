{stdenv, fetchFromGitHub, pkgconfig, ncurses, libnl }:

stdenv.mkDerivation rec {
  name = "horst-${version}";
  version = "5.0";

  src = fetchFromGitHub {
    owner = "br101";
    repo = "horst";
    rev = "version-${version}";
    sha256 = "0m7gc6dj816z8wyq5bdkqj7fw6rmxaah84s34ncsaispz2llva1x";
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
