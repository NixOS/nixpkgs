{ stdenv, fetchurl, SDL, ncurses, libtcod, binutils }:

stdenv.mkDerivation rec {
  name = "brogue-${version}";
  version = "1.7.4";

  src = fetchurl {
    url = "https://sites.google.com/site/broguegame/brogue-${version}-linux-amd64.tbz2";
    sha256 = "1lygf17hm7wqlp0jppaz8dn9a9ksmxz12vw7jyfavvqpwdgz79gb";
  };

  prePatch = ''
    sed -i Makefile -e 's,LIBTCODDIR=.*,LIBTCODDIR=${libtcod},g' \
                    -e 's,sdl-config,${SDL}/bin/sdl-config,g'
    sed -i src/platform/tcod-platform.c -e "s,fonts/font,$out/bin/fonts/font,g"
    make clean
    rm -rf src/libtcod*
  '';

  buildInputs = [ SDL ncurses binutils libtcod ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r bin/* $out/bin/
  '';

  meta = with stdenv.lib; {
    description = "Brogue is a Roguelike game for Mac OS X, Windows and Linux by Brian Walker.";
    homepage = https://sites.google.com/site/broguegame/;
    license = licenses.gpl3;
    maintainers = [maintainers.skeidel];
    platforms = ["x86_64-linux"];
  };
}
