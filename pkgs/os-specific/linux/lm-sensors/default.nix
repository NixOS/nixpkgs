{ stdenv, fetchurl, bison, flex, which, perl }:

stdenv.mkDerivation rec {
  name = "lm-sensors-${version}";
  version = "3.4.0"; # don't forget to tweak fedoraproject mirror URL hash
  
  src = fetchurl {
    urls = [
      "http://dl.lm-sensors.org/lm-sensors/releases/lm_sensors-${version}.tar.bz2"
      "http://pkgs.fedoraproject.org/repo/pkgs/lm_sensors/lm_sensors-${version}.tar.bz2/c03675ae9d43d60322110c679416901a/lm_sensors-${version}.tar.bz2"
    ];
    sha256 = "07q6811l4pp0f7pxr8bk3s97ippb84mx5qdg7v92s9hs10b90mz0";
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
