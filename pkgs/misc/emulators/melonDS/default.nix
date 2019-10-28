{ stdenv, fetchFromGitHub, cmake, pkgconfig, SDL2, gtk3, curl, libpcap }:

stdenv.mkDerivation rec {
  pname = "melonDS";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "Arisotura";
    repo = pname;
    rev = version;
    sha256 = "1lqmfwjpkdqfkns1aaxlp4yrg6i0r66mxfr4rrj7b5286k44hqwn";
  };

  enableParallelBuilding = true;
  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ SDL2 gtk3 curl libpcap ];

  postInstall = ''
    install -Dm644 romlist.bin "$out/share/melonDS/romlist.bin"
  '';

  meta = with stdenv.lib; {
    homepage = "http://melonds.kuribo64.net/";
    description = "Work in progress Nintendo DS emulator";
    license = licenses.gpl3;
    maintainers = with maintainers; [ artemist ];
    platforms = platforms.linux;
  };
}
