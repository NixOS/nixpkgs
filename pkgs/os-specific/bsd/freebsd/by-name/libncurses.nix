{ lib, hostVersion, mkDerivation, libncurses-tinfo, ...}:
mkDerivation {
  path = "lib/ncurses/ncurses";
  extraPaths = ["lib/ncurses" "contrib/ncurses" "lib/Makefile.inc"];
  #patches = /${patchesRoot}/tinfo-host-cc.patch;
  #CC_HOST = "${pkgsBuildBuild.stdenv.cc}/bin/cc";
  MK_TESTS = "no";
  clangFixup = true;
  preBuild = lib.optionalString (hostVersion != "13.2") ''
    make -C ../tinfo $makeFlags curses.h ncurses_dll.h ncurses_def.h
  '';
  buildInputs = lib.optionals (hostVersion != "13.2") [libncurses-tinfo];

  # some packages depend on libncursesw.so.8
  postInstall = ''
    ln -s $out/lib/libncursesw.so.9 $out/lib/libncursesw.so.8
  '';

  #makeFlags = [
  #  "STRIP=-s" # flag to install, not command
  #] ++ lib.optional (!stdenv.hostPlatform.isFreeBSD) "MK_WERROR=no";
}
