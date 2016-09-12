{ stdenv, fetchurl, allegro }:
stdenv.mkDerivation rec {
  version = "5.6.4";
  name = "liquidwar5-${version}";
  src = fetchurl {
    url = "http://download.savannah.gnu.org/releases/liquidwar/liquidwar-${version}.tar.gz";
    sha256 = "18wkbfzp07yckg05b5gjy67rw06z9lxp0hzg0zwj7rz8i12jxi9j";
  };

  buildInputs = [ allegro ];

  configureFlags = stdenv.lib.optional stdenv.isx86_64 "--disable-asm";

  hardeningDisable = [ "format" ];

  meta = with stdenv.lib; {
    description = ''The classic version of a quick tactics game LiquidWar'';
    maintainers = [ maintainers.raskin ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
