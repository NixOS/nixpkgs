{stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "collectd-5.4.0";
  
  src = fetchurl {
    url = "http://collectd.org/files/${name}.tar.bz2";
    sha256 = "0gljf5c60q6i0nrii6addxy1p76qqixww8zy17a7a1zil6a3i5wh";
  };

  NIX_LDFLAGS = "-lgcc_s"; # for pthread_cancel

  meta = {
    homepage = http://collectd.org;
    description = "collectd is a daemon which collects system performance statistics periodically";
    platforms = stdenv.lib.platforms.linux;
    license = "GPLv2";
  };
}
