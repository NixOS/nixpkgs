{
  lib,
  stdenv,
  fetchurl,
  allegro,
}:
stdenv.mkDerivation rec {
  version = "5.6.6";
  pname = "liquidwar5";
  src = fetchurl {
    url = "http://www.ufoot.org/download/liquidwar/v5/${version}/liquidwar-${version}.tar.gz";
    sha256 = "sha256-JF2AZuzDiCm9EQ8AiQ6230TgmMgML7yJpG80BFqsQ/c=";
  };

  buildInputs = [ allegro ];

  configureFlags = lib.optional stdenv.hostPlatform.isx86_64 "--disable-asm";

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
