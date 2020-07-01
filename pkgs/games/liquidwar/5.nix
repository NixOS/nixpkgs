{ stdenv, fetchurl, allegro }:
stdenv.mkDerivation rec {
  version = "5.6.4";
  pname = "liquidwar5";
  src = fetchurl {
    url = "https://download.savannah.gnu.org/releases/liquidwar/liquidwar-${version}.tar.gz";
    sha256 = "18wkbfzp07yckg05b5gjy67rw06z9lxp0hzg0zwj7rz8i12jxi9j";
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
    broken = true;
  };
}
