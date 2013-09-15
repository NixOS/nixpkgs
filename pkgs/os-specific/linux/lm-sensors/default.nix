{ stdenv, fetchurl, bison, flex, which, perl }:

let version = "3.3.4"; in

stdenv.mkDerivation rec {
  name = "lm-sensors-${version}";
  
  src = fetchurl {
    url = "http://dl.lm-sensors.org/lm-sensors/releases/lm_sensors-${version}.tar.bz2";
    sha256 = "0vd7dgpcri7cbvgl5fwvja53lqz829vkbbp17x7b5r2xrc88cq5l";
  };

  buildInputs = [ bison flex which perl ];

  preBuild = ''
    makeFlagsArray=(PREFIX=$out ETCDIR=$out/etc)
  '';

  meta = {
    homepage = http://www.lm-sensors.org/;
    description = "Tools for reading hardware sensors";
  };
}
