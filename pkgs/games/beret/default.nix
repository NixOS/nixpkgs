{ stdenv, fetchurl, SDL, SDL_image, SDL_ttf, SDL_mixer }:

stdenv.mkDerivation {
  name = "beret-1.2.0";

  buildInputs = [ SDL SDL_image SDL_ttf SDL_mixer ];

  NIX_CFLAGS_COMPILE = "-I${SDL}/include/SDL";

  NIX_CFLAGS_LINK = "-lgcc_s";

  patches = [ ./use-home-dir.patch ];

  postPatch = ''
    sed -i 's@RESOURCE_PATH ""@RESOURCE_PATH "'$out'/share/"@' game.c
  '';

  src = fetchurl {
    url = https://gitorious.org/beret/beret/archive-tarball/ae029777;
    name = "beret-1.2.0.tar.gz";
    sha256 = "0md00ipacvz5mq8q83h7xbzycnwympr06pc1n5c351swjvyw0ysx";
  };

  installPhase = ''
    mkdir -p $out/bin
    install -v -m755 beret $out/bin
    mkdir -p $out/share
    cp -av tahoma.ttf images music rooms sfx $out/share
  '';

  meta = {
    description = "A 2D puzzle-platformer game about a scientist with telekinetic abilities";
    homepage = http://kiwisauce.com/beret/;
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.lgpl2;
  };
}

