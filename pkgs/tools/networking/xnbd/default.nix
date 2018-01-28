{ stdenv, fetchurl, pkgconfig, glib }:

stdenv.mkDerivation rec {
  name = "xnbd-0.3.0";

  src = fetchurl {
    url = "https://bitbucket.org/hirofuchi/xnbd/downloads/${name}.tar.bz2";
    sha256 = "0jlv6cx85sjn8vjhgzmcs5mz2b6xf18mp0h61v1gl7xkbalw1flb";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ glib ];

  meta = {
    homepage = https://bitbucket.org/hirofuchi/xnbd;
    description = "Yet another NBD (Network Block Device) server program";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.volth ];
    platforms = stdenv.lib.platforms.linux;
  };
}
