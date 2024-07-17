{
  lib,
  stdenv,
  fetchurl,
  allegro,
}:
stdenv.mkDerivation rec {
  version = "5.6.5";
  pname = "liquidwar5";
  src = fetchurl {
    url = "http://www.ufoot.org/download/liquidwar/v5/${version}/liquidwar-${version}.tar.gz";
    sha256 = "2tCqhN1BbK0FVCHtm0DfOe+ueNPfdZwFg8ZMVPfy/18=";
  };

  buildInputs = [ allegro ];

  configureFlags = lib.optional stdenv.isx86_64 "--disable-asm";

  hardeningDisable = [ "format" ];

  env.NIX_CFLAGS_COMPILE = toString [
    # Workaround build failure on -fno-common toolchains like upstream
    # gcc-10. Otherwise build fails as:
    #   ld: random.o:(.bss+0x0): multiple definition of `LW_RANDOM_ON'; game.o:(.bss+0x4): first defined here
    "-fcommon"

    "-lm"
  ];

  meta = with lib; {
    description = "Classic version of a quick tactics game LiquidWar";
    maintainers = [ maintainers.raskin ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
