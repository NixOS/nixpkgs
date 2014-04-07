{stdenv, fetchurl}:
stdenv.mkDerivation {
  name = "units-2.10";

  src = fetchurl {
    url = mirror://gnu/units/units-2.10.tar.gz;
    sha256 = "0fa4bk5aqyis5zisz6l8mqqk76njj6zgx3pbrjp5kvraz1dz78lc";
  };

  meta = {
    description = "Unit conversion tool";
    platforms = stdenv.lib.platforms.linux;
  };
}
