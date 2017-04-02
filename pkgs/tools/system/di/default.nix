{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "di-${version}";
  version = "4.43";

  src = fetchurl {
    url = "http://gentoo.com/di/${name}.tar.gz";
    sha256 = "1q25jy51qfzsym9b2w0cqzscq2j492gn60dy6gbp88m8nwm4sdy8";
  };

  makeFlags = [ "INSTALL_DIR=$(out)" ];

  meta = with stdenv.lib; {
    description = "Disk information utility; displays everything 'df' does and more";
    homepage = http://www.gentoo.com/di/;
    license = licenses.zlib;
    maintainers = with maintainers; [ manveru ndowens ];
    platforms = platforms.all;
  };
}
