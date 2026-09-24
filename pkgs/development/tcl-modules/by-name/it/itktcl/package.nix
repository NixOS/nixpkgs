{
  lib,
  stdenv,
  fetchurl,
  mkTclDerivation,
  tk,
  incrtcl,
}:

mkTclDerivation rec {
  pname = "itk-tcl";
  version = "4.1.0";

  src = fetchurl {
    url = "mirror://sourceforge/incrtcl/%5BIncr%20Tcl_Tk%5D-source/3.4/itk${version}.tar.gz";
    hash = "sha256-2mRhmSIu/cTYyZWThjyNKHRC6lqGh/lUYNbp5yQxycc=";
  };

  buildInputs = [
    tk
    incrtcl
  ];
  enableParallelBuilding = true;

  configureFlags = [
    "--with-tk=${tk}/lib"
    "--with-itcl=${incrtcl}/lib"
    "--with-tkinclude=${tk.dev}/include"
  ];

  postInstall = ''
    rmdir $out/bin
    mv $out/lib/itk${version}/* $out/lib
    ln -s libitk${version}${stdenv.hostPlatform.extensions.sharedLibrary} \
      $out/lib/libitk${lib.versions.major version}${stdenv.hostPlatform.extensions.sharedLibrary}
    rmdir $out/lib/itk${version}
  '';

  outputs = [
    "out"
    "dev"
    "man"
  ];

  meta = {
    homepage = "https://incrtcl.sourceforge.net/";
    description = "Mega-widget toolkit for incr Tk";
    license = lib.licenses.tcltk;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ thoughtpolice ];
  };
}
