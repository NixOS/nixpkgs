{ stdenv, fetchurl, SDL, SDL_image, SDL_ttf, SDL_mixer }:

stdenv.mkDerivation {
  name = "beret-1.2.0";

  buildInputs = [ SDL SDL_image SDL_ttf SDL_mixer ];

  NIX_CFLAGS_COMPILE = "-I${SDL}/include/SDL";
  NIX_CFLAGS_LINK = stdenv.lib.optionalString (!stdenv.isDarwin) "-lgcc_s";
  NIX_LDFLAGS = stdenv.lib.optionalString stdenv.isDarwin
    "-framework CoreFoundation -framework OpenGL -framework Cocoa";

  patches = [ ./use-home-dir.patch ];

  postPatch = ''
    sed -i 's@RESOURCE_PATH ""@RESOURCE_PATH "'$out'/share/"@' game.c
  '';

  src = fetchurl {
    url = https://gitorious.org/beret/beret/archive-tarball/ae029777;
    name = "beret-1.2.0.tar.gz";
    sha256 = "14283p27y7g8dq9is7n8zlfslv370pia414frp18722279ps6gqp";
  };

  installPhase = ''
    mkdir -p $out/bin
    install -v -m755 beret $out/bin
    mkdir -p $out/share
    cp -av tahoma.ttf images music rooms sfx $out/share
  '';

  meta = with stdenv.lib; {
    description = "A 2D puzzle-platformer game about a scientist with telekinetic abilities";
    homepage    = http://kiwisauce.com/beret/;
    license     = licenses.lgpl2;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.all;
  };
}

