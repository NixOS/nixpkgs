{
  lib,
  fetchsvn,
  tcl,
  tcllib,
  tk,
  libx11,
}:

tcl.mkTclDerivation rec {
  pname = "tkimg";
  version = "623";

  src = fetchsvn {
    url = "svn://svn.code.sf.net/p/tkimg/code/trunk";
    rev = version;
    sha256 = "sha256-6GlkqYxXmMGjiJTZS2fQNVSimcKc1BZ/lvzvtkhty+o=";
  };

  configureFlags = [
    "--with-tcl=${tcl}/lib"
    "--with-tk=${tk}/lib"
    "--with-tkinclude=${tk.dev}/include"
  ];

  buildInputs = [
    libx11
    tcllib
  ];

  meta = {
    homepage = "https://sourceforge.net/projects/tkimg/";
    description = "Img package adds several image formats to Tcl/Tk";
    maintainers = with lib.maintainers; [ matthewcroughan ];
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    badPlatforms = lib.platforms.darwin;
  };
}
