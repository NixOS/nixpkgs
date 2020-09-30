{ stdenv, fetchFromGitHub, autoreconfHook, wxGTK30, libav, lua5_1, curl
, libpng, xorg, pkgconfig, flam3, libgtop, boost, tinyxml, freeglut, libGLU, libGL
, glee }:

stdenv.mkDerivation rec {
  pname = "electricsheep";
  version = "3.0.2-2019-10-05";

  src = fetchFromGitHub {
    owner = "scottdraves";
    repo = pname;
    rev = "37ba0fd692d6581f8fe009ed11c9650cd8174123";
    sha256 = "1z49l53j1lhk7ahdy96lm9r0pklwpf2i5s6y2l2rn6l4z8dxkjmk";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  buildInputs = [
    wxGTK30 libav lua5_1 curl libpng xorg.libXrender
    flam3 libgtop boost tinyxml freeglut libGLU libGL glee
  ];

  preAutoreconf = ''
    cd client_generic
    sed -i '/ACX_PTHREAD/d' configure.ac
  '';

  configureFlags = [
    "CPPFLAGS=-I${glee}/include/GL"
  ];

  makeFlags = [
    ''CXXFLAGS+="-DGL_GLEXT_PROTOTYPES"''
  ];

  preBuild = ''
    sed -i "s|/usr|$out|" Makefile
  '';

  meta = with stdenv.lib; {
    description = "Electric Sheep, a distributed screen saver for evolving artificial organisms";
    homepage = "https://electricsheep.org/";
    maintainers = with maintainers; [ nand0p fpletz ];
    platforms = platforms.linux;
    license = licenses.gpl1;
  };
}
