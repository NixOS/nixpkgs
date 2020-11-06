{ stdenv, fetchurl, allegro }:
stdenv.mkDerivation rec {
  version = "5.6.5";
  pname = "liquidwar5";
  src = fetchurl {
    url = "http://www.ufoot.org/download/liquidwar/v5/${version}/liquidwar-${version}.tar.gz";
    sha256 = "2tCqhN1BbK0FVCHtm0DfOe+ueNPfdZwFg8ZMVPfy/18=";
  };

  buildInputs = [ allegro ];

  configureFlags = stdenv.lib.optional stdenv.isx86_64 "--disable-asm";

  hardeningDisable = [ "format" ];

  NIX_CFLAGS_COMPILE = [ "-lm" ];

  meta = with stdenv.lib; {
    description = ''The classic version of a quick tactics game LiquidWar'';
    maintainers = [ maintainers.raskin ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
