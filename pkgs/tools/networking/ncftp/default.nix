{stdenv, fetchurl, ncurses, coreutils}:

stdenv.mkDerivation {
  name = "ncftp-3.2.3";

  src = fetchurl {
    url = ftp://ftp.ncftp.com/ncftp/ncftp-3.2.4-src.tar.bz2;
    sha256 = "0v0cfc4kqsvmfighl47djw5nw82dl5j5g5i2s8wy375fllim0cv6";
  };

  preConfigure = ''
    find . -name "*.sh" -type f | xargs sed 's@/bin/ls@${coreutils}/bin/ls@g' -i
    find . -name "*.in" -type f | xargs sed 's@/bin/ls@${coreutils}/bin/ls@g' -i
    find . -name "*.c" -type f | xargs sed 's@/bin/ls@${coreutils}/bin/ls@g' -i
    sed 's@/bin/ls@${coreutils}/bin/ls@g' -i configure

    find . -name "*.sh" -type f | xargs sed 's@/bin/rm@${coreutils}/bin/rm@g' -i
    find . -name "*.in" -type f | xargs sed 's@/bin/rm@${coreutils}/bin/rm@g' -i
    find . -name "*.c" -type f | xargs sed 's@/bin/rm@${coreutils}/bin/rm@g' -i
    sed 's@/bin/rm@${coreutils}/bin/rm@g' -i configure
  '';

  meta = {
    description = "NcFTP Client (also known as just NcFTP) is a set of FREE application programs implementing the File Transfer Protocol (FTP).";
    homepage = http://www.ncftp.com/ncftp/;
  };
}
