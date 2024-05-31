{
  lib,
  mkDerivation,
  libterminfo,
  libcurses,
  compatIfNeeded,
  defaultMakeFlags,
}:

mkDerivation {
  path = "lib/libedit";
  version = "9.2";
  sha256 = "1wqhngraxwqk4jgrf5f18jy195yrp7c06n1gf31pbplq79mg1bcj";
  buildInputs = [
    libterminfo
    libcurses
  ];
  propagatedBuildInputs = compatIfNeeded;
  SHLIBINSTALLDIR = "$(out)/lib";
  makeFlags = defaultMakeFlags ++ [ "LIBDO.terminfo=${libterminfo}/lib" ];
  postPatch = ''
    sed -i '1i #undef bool_t' $COMPONENT_PATH/el.h
    substituteInPlace $COMPONENT_PATH/config.h \
      --replace "#define HAVE_STRUCT_DIRENT_D_NAMLEN 1" ""
    substituteInPlace $COMPONENT_PATH/readline/Makefile --replace /usr/include "$out/include"
  '';
  env.NIX_CFLAGS_COMPILE = toString [
    "-D__noinline="
    "-D__scanflike(a,b)="
    "-D__va_list=va_list"
  ];
}
