{ lib, hostVersion, mkDerivation, libncurses-tinfo, ...}:
mkDerivation {
  path = "lib/ncurses/ncurses";
  extraPaths = ["lib/ncurses" "contrib/ncurses" "lib/Makefile.inc"];
  #patches = /${patchesRoot}/tinfo-host-cc.patch;
  #CC_HOST = "${pkgsBuildBuild.stdenv.cc}/bin/cc";
  MK_TESTS = "no";
  preBuild = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -D_VA_LIST -D_VA_LIST_DECLARED -Dva_list=__builtin_va_list -D_SIZE_T -D_WCHAR_T"
  '' + lib.optionalString (hostVersion != "freebsd13") ''
    make -C ../tinfo $makeFlags curses.h ncurses_dll.h ncurses_def.h
  '';
  buildInputs = lib.optionals (hostVersion != "freebsd13") [libncurses-tinfo];

  # some packages depend on libncursesw.so.8
  postInstall = ''
    ln -s $out/lib/libncursesw.so.9 $out/lib/libncursesw.so.8
  '';

  #makeFlags = [
  #  "STRIP=-s" # flag to install, not command
  #] ++ lib.optional (!stdenv.hostPlatform.isFreeBSD) "MK_WERROR=no";
}
