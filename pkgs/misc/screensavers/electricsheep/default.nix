{ stdenv, fetchFromGitHub, autoreconfHook, wxGTK30, libav, lua5_1, curl
, libpng, xorg, pkgconfig, flam3, libgtop, boost, tinyxml, freeglut, mesa
, glee }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "electricsheep";
  version = "2.7b33-2017-02-04";

  src = fetchFromGitHub {
    owner = "scottdraves";
    repo = pname;
    rev = "12420cd40dfad8c32fb70b88f3d680d84f795c63";
    sha256 = "1zqry25h6p0y0rg2h8xxda007hx1xdvsgzmjg13xkc8l4zsp5wah";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  buildInputs = [
    wxGTK30 libav lua5_1 curl libpng xorg.libXrender
    flam3 libgtop boost tinyxml freeglut mesa glee
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
