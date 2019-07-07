{ stdenv, ncurses, customConfig ? null, name, src, patches ? [] }:
stdenv.mkDerivation rec {

  inherit name src patches;

  CFLAGS = stdenv.lib.optionalString stdenv.isDarwin "-D_DARWIN_C_SOURCE";

  postPatch = stdenv.lib.optionalString (customConfig != null) ''
    cp ${builtins.toFile "config.h" customConfig} ./config.h
  '';

  buildInputs = [ ncurses ];

  prePatch = ''
    substituteInPlace Makefile \
      --replace /usr/share/terminfo $out/share/terminfo
  '';

  installPhase = ''
    make PREFIX=$out install
  '';

  meta = with stdenv.lib; {
    description = "Dynamic virtual terminal manager";
    homepage = http://www.brain-dump.org/projects/dvtm;
    license = licenses.mit;
    maintainers = [ maintainers.vrthra ];
    platforms = platforms.unix;
  };
}
