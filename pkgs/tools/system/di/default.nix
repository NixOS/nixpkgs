{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "di-4.37";

  src = fetchurl {
    url = "http://gentoo.com/di/${name}.tar.gz";
    sha256 = "1ljamhbpfps5b3n6gsk11znjv2f0cqfy7imda2qmzrlb8dipjs0h";
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
