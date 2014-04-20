{stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "collectd-5.4.1";
  
  src = fetchurl {
    url = "http://collectd.org/files/${name}.tar.bz2";
    sha256 = "1q365zx6d1wyhv7n97bagfxqnqbhj2j14zz552nhmjviy8lj2ibm";
  };

  NIX_LDFLAGS = "-lgcc_s"; # for pthread_cancel

  meta = {
    homepage = http://collectd.org;
    description = "collectd is a daemon which collects system performance statistics periodically";
    platforms = stdenv.lib.platforms.linux;
    license = "GPLv2";
  };
}
