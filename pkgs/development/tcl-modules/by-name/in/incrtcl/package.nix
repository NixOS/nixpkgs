{
  lib,
  stdenv,
  mkTclDerivation,
  fetchurl,
  writeText,
  tcl,
}:

mkTclDerivation rec {
  pname = "incrtcl";
  version = "4.2.3";

  src = fetchurl {
    url = "mirror://sourceforge/incrtcl/%5BIncr%20Tcl_Tk%5D-source/3.4/itcl${version}.tar.gz";
    sha256 = "sha256-idOs2GXP3ZY7ECtF+K9hg5REyK6sQ0qk+666gUQPjCY=";
  };

  enableParallelBuilding = true;

  patchPhase = ''
    substituteInPlace configure --replace "\''${TCL_SRC_DIR}/generic" "${tcl}/include"
  '';

  postInstall = ''
    rmdir $out/bin
    mv $out/lib/itcl${version}/* $out/lib
    ln -s libitcl${version}${stdenv.hostPlatform.extensions.sharedLibrary} \
      $out/lib/libitcl${lib.versions.major version}${stdenv.hostPlatform.extensions.sharedLibrary}
    rmdir $out/lib/itcl${version}
  '';

  setupHook = writeText "setup-hook.sh" ''
    export ITCL_LIBRARY=@out@/lib
  '';

  outputs = [
    "out"
    "dev"
    "man"
  ];

  meta = with lib; {
    homepage = "https://incrtcl.sourceforge.net/";
    description = "Object Oriented Enhancements for Tcl/Tk";
    license = licenses.tcltk;
    platforms = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
