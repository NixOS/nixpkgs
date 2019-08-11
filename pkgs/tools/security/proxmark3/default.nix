{ stdenv, fetchFromGitHub, pkgconfig, ncurses, readline }:

stdenv.mkDerivation rec {
  pname = "proxmark3";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "Proxmark";
    repo = pname;
    rev = "v${version}";
    sha256 = "1qw28n1bhhl91ix77lv50qcr919fq3hjc8zhhqphwxal2svgx2jf";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ ncurses readline ];

  postPatch = ''
    substituteInPlace client/Makefile --replace '-ltermcap' ' '
    substituteInPlace liblua/Makefile --replace '-ltermcap' ' '
  '';

  preBuild = ''
    cd client
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp proxmark3 $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Client for proxmark3,  powerful general purpose RFID tool";
    homepage = http://www.proxmark.org;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ fpletz ];
  };
}
