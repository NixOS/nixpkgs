{ stdenv, fetchFromGitHub, autoreconfHook, libtool, wxGTK30, libav, lua5_1, curl,
  libpng, xorg, pkgconfig, flam3, libgtop, boost, tinyxml, freeglut, mesa, glee }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "electricsheep";
  version = "2.7b33-${stdenv.lib.strings.substring 0 7 rev}";
  rev = "598d93d90573b69559463567540aac8bc8a5b3f3";
  
  src = fetchFromGitHub {
    inherit rev;
    owner = "scottdraves";
    repo = "${pname}";
    sha256 = "1zcn6q0dl0ip85b8b4kisc5lqjb1cs0hpzlx4l5995l6mhq9kxis";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [
    libtool wxGTK30 libav lua5_1 curl libpng xorg.libXrender pkgconfig
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
    maintainers = maintainers.nand0p;
    platforms = platforms.linux;
    license = licenses.gpl1;
  };
}
