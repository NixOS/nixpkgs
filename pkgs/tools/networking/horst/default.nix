{stdenv, fetchFromGitHub, pkgconfig, ncurses, libnl }:

stdenv.mkDerivation rec {
  pname = "horst";
  version = "5.1";

  src = fetchFromGitHub {
    owner = "br101";
    repo = "horst";
    rev = "v${version}";
    sha256 = "140pyv6rlsh4c745w4b59pz3hrarr39qq3mz9z1lsd3avc12nx1a";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ ncurses libnl ];

  installFlags = [ "DESTDIR=${placeholder "out"}" ];

  meta = with stdenv.lib; {
    description = "Small and lightweight IEEE802.11 wireless LAN analyzer with a text interface";
    homepage = "http://br1.einfach.org/tech/horst/";
    maintainers = [ maintainers.fpletz ];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
