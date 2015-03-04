{ stdenv, fetchurl, cmake, gengetopt, libX11, libXext, cppcheck}:

stdenv.mkDerivation rec {
  name = "slop-${version}";
  version = "4.1.15";

  src = fetchurl {
    url = "https://github.com/naelstrof/slop/archive/v${version}.tar.gz";
    sha256 = "e20fd47de898abcb537c8100faed859eef4955d7784dbc52470570dae403f02e";
  };

  buildInputs = [ cmake gengetopt libX11 libXext ]
                ++ stdenv.lib.optional doCheck cppcheck;

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/naelstrof/slop;
    description = "Queries a selection from the user and prints to stdout";
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = with maintainers; [ mbakke ];
  };
}
