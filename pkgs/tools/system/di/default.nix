{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "di-4.35";

  src = fetchurl {
    url = "http://gentoo.com/di/${name}.tar.gz";
    sha256 = "1lkiggvdm6wi14xy8845w6mqqr50j2q7g0i2rdcs7qw5gb7gmprc";
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
