{ stdenv, fetchzip, fltk, zlib, xdg_utils, xorg, libjpeg, libGL }:

stdenv.mkDerivation rec {
  name = "eureka-editor-${version}";
  version = "1.21";
  shortver = "121";

  src = fetchzip {
    url = "mirror://sourceforge/eureka-editor/Eureka/${version}/eureka-${shortver}-source.tar.gz";
    sha256 = "0fpj13aq4wh3f7473cdc5jkf1c71jiiqmjc0ihqa0nm3hic1d4yv";
  };

  buildInputs = [ fltk zlib xdg_utils libjpeg xorg.libXinerama libGL ];

  enableParallelBuilding = true;

  preBuild = ''
    substituteInPlace src/main.cc \
      --replace /usr/local $out
    substituteInPlace Makefile \
      --replace /usr/local $out \
      --replace "-o root " ""
  '';

  preInstall = "mkdir -p $out/bin";

  meta = with stdenv.lib; {
    homepage = http://eureka-editor.sourceforge.net;
    description = "A map editor for the classic DOOM games, and a few related games such as Heretic and Hexen";
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = with maintainers; [ neonfuz ];
  };
}
