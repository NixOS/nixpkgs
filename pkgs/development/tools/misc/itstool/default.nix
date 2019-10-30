{ stdenv, fetchurl, python2 }:

stdenv.mkDerivation rec {
  # 2.0.3+ breaks the build of gnome3.gnome-desktop
  # https://github.com/itstool/itstool/issues/17
  name = "itstool-2.0.2";

  src = fetchurl {
    url = "http://files.itstool.org/itstool/${name}.tar.bz2";
    sha256 = "bf909fb59b11a646681a8534d5700fec99be83bb2c57badf8c1844512227033a";
  };

  buildInputs = [ (python2.withPackages(ps: with ps; [ libxml2 ])) ];

  meta = {
    homepage = http://itstool.org/;
    description = "XML to PO and back again";
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ ];
  };
}
