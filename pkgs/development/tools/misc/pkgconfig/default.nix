{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "pkgconfig-0.22";
  setupHook = ./setup-hook.sh;
  src = fetchurl {
    url = http://pkgconfig.freedesktop.org/releases/pkg-config-0.22.tar.gz;
    sha256 = "1rpb5wygmp0f8nal7y3ga4556i7hkjdslv3wdq04fj30gns621vy";
  };
}

