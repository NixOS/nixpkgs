{
  lib,
  mkTclDerivation,
  fetchzip,
  graphicsmagick,
  tcl,
  tk,
}:

mkTclDerivation (finalAttrs: {
  pname = "tclmagick";
  version = "1.3.43";

  src = fetchzip {
    url = "mirror://sourceforge/graphicsmagick/GraphicsMagick-${finalAttrs.version}.tar.xz";
    hash = "sha256-CpZztiBF0HqH4XWIAyE9IbZVpBcgrDzyASv47wTneQ0=";
  };

  sourceRoot = finalAttrs.src.name + "/TclMagick";

  nativeBuildInputs = [
    graphicsmagick # for GraphicsMagickWand-config script
  ];

  buildInputs = [
    graphicsmagick
    tk
  ];

  configureFlags = [
    "--with-tk=${lib.getLib tk}/lib"
    "--with-tkinclude=${lib.getDev tk}/include"
  ];

  doInstallCheck = true;

  meta = {
    description = "Tcl and Tk Interfaces to GraphicsMagick and ImageMagick";
    homepage = "http://www.graphicsmagick.org/TclMagick/doc/";
    license = lib.licenses.tcltk;
    maintainers = with lib.maintainers; [ fgaz ];
    broken = tcl.isTcl9;
  };
})
