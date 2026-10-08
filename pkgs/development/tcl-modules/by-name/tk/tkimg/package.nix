{
  lib,
  fetchzip,
  tcl,
  tcllib,
  tk,
  libx11,
  zlib,
}:

tcl.mkTclDerivation rec {
  pname = "tkimg";
  version = "2.1.1";

  src = fetchzip {
    url = "mirror://sourceforge/tkimg/tkimg/Img-${version}.tar.gz";
    hash = "sha256-TRtE2/BVrYgkdKtbF06UjLvokokgLGQ/EKDLxhz2Ckw=";
  };

  configureFlags = [
    "--with-tcl=${tcl}/lib"
    "--with-tk=${tk}/lib"
    "--with-tkinclude=${tk.dev}/include"
  ];

  buildInputs = [
    libx11
    tcllib
    zlib
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
