{stdenv, fetchurl, bison, flex, perl}:

stdenv.mkDerivation rec {
  name = "lm_sensors-3.1.1";
  
  src = fetchurl {
    url = "http://dl.lm-sensors.org/lm-sensors/releases/${name}.tar.bz2";
    sha256 = "1vsrs2cl35h2gry03lp0pwbzpw0nbpsbpds5w4mdmx16clm3ynnr";
  };

  buildInputs = [bison flex perl];

  preBuild = ''
    makeFlagsArray=(PREFIX=$out ETCDIR=$out/etc)
  '';

  meta = {
    homepage = http://www.lm-sensors.org/;
    description = "Tools for reading hardware sensors";
  };
}
