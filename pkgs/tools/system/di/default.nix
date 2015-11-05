{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "di-4.36";

  src = fetchurl {
    url = "http://gentoo.com/di/${name}.tar.gz";
    sha256 = "11kd9jawpkir6qwjciis9l5fdvgbp9yndcv4rg6k3x9x1and40zb";
  };

  makeFlags = "INSTALL_DIR=$(out)";

  meta = with stdenv.lib; {
    description = "A disk information utility, displaying everything (and more) that your 'df' command does";
    homepage = http://www.gentoo.com/di/;
    license = licenses.zlib;
    maintainers = with maintainers; [ manveru ];
    platforms = platforms.all;
  };
}
