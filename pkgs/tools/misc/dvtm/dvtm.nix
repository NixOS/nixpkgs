{ lib, stdenv, ncurses, customConfig ? null, name, src, patches ? [] }:
stdenv.mkDerivation {

  inherit name src patches;

  CFLAGS = lib.optionalString stdenv.isDarwin "-D_DARWIN_C_SOURCE";

  postPatch = lib.optionalString (customConfig != null) ''
    cp ${builtins.toFile "config.h" customConfig} ./config.h
  '';

  nativeBuildInputs = [ ncurses ];
  buildInputs = [ ncurses ];

  prePatch = ''
    substituteInPlace Makefile \
      --replace /usr/share/terminfo $out/share/terminfo
  '';

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Dynamic virtual terminal manager";
    homepage = "http://www.brain-dump.org/projects/dvtm";
    license = licenses.mit;
    maintainers = [ maintainers.vrthra ];
    platforms = platforms.unix;
  };
}
