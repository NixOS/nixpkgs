{ sensord ? false,
  stdenv, fetchurl, bison, flex, which, perl,
  rrdtool ? null
}:

assert sensord -> rrdtool != null;

stdenv.mkDerivation rec {
  name = "lm-sensors-${version}";
  version = "3.4.0"; # don't forget to tweak fedoraproject mirror URL hash

  src = fetchurl {
    urls = [
      # "http://dl.lm-sensors.org/lm-sensors/releases/lm_sensors-${version}.tar.bz2" # dead
      # https://github.com/lm-sensors/lm-sensors/releases/... # only generated tarballs
      "https://src.fedoraproject.org/repo/pkgs/lm_sensors/lm_sensors-${version}.tar.bz2/c03675ae9d43d60322110c679416901a/lm_sensors-${version}.tar.bz2"
    ];
    sha256 = "07q6811l4pp0f7pxr8bk3s97ippb84mx5qdg7v92s9hs10b90mz0";
  };

  buildInputs = [ bison flex which perl ]
   ++ stdenv.lib.optional sensord rrdtool;

  patches = [ ./musl-fix-includes.patch ];

  preBuild = ''
    makeFlagsArray=(PREFIX=$out ETCDIR=$out/etc
    ${stdenv.lib.optionalString sensord "PROG_EXTRA=sensord"})
  '';

  meta = with stdenv.lib; {
    homepage = https://hwmon.wiki.kernel.org/lm_sensors;
    description = "Tools for reading hardware sensors";
    license = with licenses; [ gpl2 lgpl21 ];
    platforms = platforms.linux;
  };
}
