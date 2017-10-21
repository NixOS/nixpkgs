{ fetchurl, stdenv, automake, autoconf, curl, autoreconfHook }:

let
  major = "2";
  minor = "22";
in stdenv.mkDerivation rec {
  name = "dirb-${version}";
  version = "${major}.${minor}";
  src = fetchurl {
    url = "mirror://sourceforge/dirb/${version}/dirb${major}${minor}.tar.gz";
    sha256 = "0b7wc2gvgnyp54rxf1n9arn6ymrvdb633v6b3ah138hw4gg8lx7k";
  };

  unpackPhase = ''
    tar -xf $src
    find . -exec chmod +x "{}" ";"
    export sourceRoot="dirb222"
  '';

  buildInputs = [ automake autoconf curl ];
  preConfigure = "chmod +x configure";

  meta = {
    description = "A web content scanner";
    homepage = http://dirb.sourceforge.net/;
    maintainers = with stdenv.lib.maintainers; [ bennofs ];
    license = with stdenv.lib.licenses; [ gpl2 ];
    platforms = stdenv.lib.platforms.unix;
  };
}
