{
  lib,
  stdenv,
  mkTclDerivation,
  fetchurl,
  writeText,
  tcl,
}:

mkTclDerivation (finalAttrs: {
  pname = "incrtcl";
  version = "4.2.3";

  src = fetchurl {
    url = "mirror://sourceforge/incrtcl/%5BIncr%20Tcl_Tk%5D-source/3.4/itcl${finalAttrs.version}.tar.gz";
    hash = "sha256-idOs2GXP3ZY7ECtF+K9hg5REyK6sQ0qk+666gUQPjCY=";
  };

  enableParallelBuilding = true;

  patchPhase = ''
    substituteInPlace configure --replace-fail "\''${TCL_SRC_DIR}/generic" "${tcl}/include"
  '';

  postInstall = ''
    rmdir $out/bin
    mv $out/lib/itcl${finalAttrs.version}/* $out/lib
    ln -s libitcl${finalAttrs.version}${stdenv.hostPlatform.extensions.sharedLibrary} \
      $out/lib/libitcl${lib.versions.major finalAttrs.version}${stdenv.hostPlatform.extensions.sharedLibrary}
    rmdir $out/lib/itcl${finalAttrs.version}
  '';

  setupHook = writeText "setup-hook.sh" ''
    export ITCL_LIBRARY=@out@/lib
  '';

  outputs = [
    "out"
    "dev"
    "man"
  ];

  meta = {
    homepage = "https://incrtcl.sourceforge.net/";
    description = "Object Oriented Enhancements for Tcl/Tk";
    license = lib.licenses.tcltk;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ thoughtpolice ];
    broken = tcl.isTcl9;
  };
})
