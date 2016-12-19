{stdenv, fetchFromGitHub, pkgconfig, ncurses, libnl }:

stdenv.mkDerivation rec {
  name = "horst-${version}";
  version = "git-2016-03-15";

  src = fetchFromGitHub {
    owner = "br101";
    repo = "horst";
    rev = "9d5c2f387607ac1c174b59497557b8985cdb788b";
    sha256 = "0a4ixc9xbc818hw7rai24i1y8nqq2aqxqd938ax89ik4pfd2w3l0";
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
