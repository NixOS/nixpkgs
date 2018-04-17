{ stdenv, fetchFromGitHub, autoreconfHook, wxGTK30, libav, lua5_1, curl
, libpng, xorg, pkgconfig, flam3, libgtop, boost, tinyxml, freeglut, libGLU_combined
, glee }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "electricsheep";
  version = "2.7b33-2017-10-20";

  src = fetchFromGitHub {
    owner = "scottdraves";
    repo = pname;
    rev = "c02c19b9364733fc73826e105fc983a89a8b4f40";
    sha256 = "1z49l53j1lhk7ahdy96lm9r0pklwpf2i5s6y2l2rn6l4z8dxkjmk";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  buildInputs = [
    wxGTK30 libav lua5_1 curl libpng xorg.libXrender
    flam3 libgtop boost tinyxml freeglut libGLU_combined glee
  ];

  preAutoreconf = ''
    cd client_generic
    sed -i '/ACX_PTHREAD/d' configure.ac
  '';

  configureFlags = [
    "CPPFLAGS=-I${glee}/include/GL"
  ];

  preBuild = ''
    sed -i "s|/usr|$out|" Makefile
  '';

  meta = with stdenv.lib; {
    description = "Electric Sheep, a distributed screen saver for evolving artificial organisms";
    homepage = http://electricsheep.org/;
    maintainers = with maintainers; [ nand0p fpletz ];
    platforms = platforms.linux;
    license = licenses.gpl1;
  };
}
