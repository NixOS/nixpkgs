{
  lib,
  mkDerivation,
  stdenv,
  libterminfo,
  compatIfNeeded,
  defaultMakeFlags,
}:

mkDerivation {
  path = "lib/libcurses";
  version = "9.2";
  sha256 = "0pd0dggl3w4bv5i5h0s1wrc8hr66n4hkv3zlklarwfdhc692fqal";
  buildInputs = [ libterminfo ];
  env.NIX_CFLAGS_COMPILE = toString (
    [
      "-D__scanflike(a,b)="
      "-D__va_list=va_list"
      "-D__warn_references(a,b)="
    ]
    ++ lib.optional stdenv.isDarwin "-D__strong_alias(a,b)="
  );
  propagatedBuildInputs = compatIfNeeded;
  MKDOC = "no"; # missing vfontedpr
  makeFlags = defaultMakeFlags ++ [ "LIBDO.terminfo=${libterminfo}/lib" ];
  postPatch = lib.optionalString (!stdenv.isDarwin) ''
    substituteInPlace $COMPONENT_PATH/printw.c \
      --replace "funopen(win, NULL, __winwrite, NULL, NULL)" NULL \
      --replace "__strong_alias(vwprintw, vw_printw)" 'extern int vwprintw(WINDOW*, const char*, va_list) __attribute__ ((alias ("vw_printw")));'
    substituteInPlace $COMPONENT_PATH/scanw.c \
      --replace "__strong_alias(vwscanw, vw_scanw)" 'extern int vwscanw(WINDOW*, const char*, va_list) __attribute__ ((alias ("vw_scanw")));'
  '';
}
