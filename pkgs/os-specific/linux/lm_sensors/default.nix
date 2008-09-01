{stdenv, fetchurl, bison, flex, perl}:

stdenv.mkDerivation {
  name = "lm_sensors-3.0.2";
  
  src = fetchurl {
    url = http://dl.lm-sensors.org/lm-sensors/releases/lm_sensors-3.0.2.tar.bz2;
    sha256 = "0msvgjbj63maibip9y8xcjm55y7crc37lbzdff5x5pk1hqpgqq8l";
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
