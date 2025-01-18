{
  lib,
  mkTclDerivation,
  fetchzip,
  graphicsmagick,
  tk,
}:

mkTclDerivation rec {
  pname = "tclmagick";
  version = "1.3.43";

  src = fetchzip {
    url = "mirror://sourceforge/graphicsmagick/GraphicsMagick-${version}.tar.xz";
    hash = "sha256-CpZztiBF0HqH4XWIAyE9IbZVpBcgrDzyASv47wTneQ0=";
  };

  sourceRoot = src.name + "/TclMagick";

  buildInputs = [
    graphicsmagick
    tk
  ];

  configureFlags = [
    "--with-tk=${lib.getLib tk}/lib"
    "--with-tkinclude=${lib.getDev tk}/include"
  ];

  doInstallCheck = true;

  meta = with lib; {
    description = "Tcl and Tk Interfaces to GraphicsMagick and ImageMagick";
    homepage = "http://www.graphicsmagick.org/TclMagick/doc/";
    license = licenses.tcltk;
    maintainers = with maintainers; [ fgaz ];
  };
}
