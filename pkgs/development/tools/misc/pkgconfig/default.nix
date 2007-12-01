{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "pkgconfig-0.22";
  setupHook = ./setup-hook.sh;
  src = fetchurl {
    url = http://pkgconfig.freedesktop.org/releases/pkg-config-0.22.tar.gz;
    sha256 = "1rpb5wygmp0f8nal7y3ga4556i7hkjdslv3wdq04fj30gns621vy";
  };

  patches = [
    # Process Requires.private properly, see
    # http://bugs.freedesktop.org/show_bug.cgi?id=4738.
    (fetchurl {
      name = "pkgconfig-8494.patch";
      url = http://bugs.freedesktop.org/attachment.cgi?id=8494;
      sha256 = "1pcrdbb7dypg2biy0yqc7bdxak5zii8agqljdvk7j4wbyghpqzws";
    })
  ];
}

