{stdenv, fetchurl, pkgconfig, glib}:

stdenv.mkDerivation {
  name = "desktop-file-utils-0.15";
  src = fetchurl {
    url = http://www.freedesktop.org/software/desktop-file-utils/releases/desktop-file-utils-0.15.tar.gz;
    md5 = "2fe8ebe222fc33cd4a959415495b7eed";
  };
  buildInputs = [ pkgconfig glib ];
}
