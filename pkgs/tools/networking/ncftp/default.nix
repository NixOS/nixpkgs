{ stdenv, fetchurl, ncurses, coreutils }:

let version = "3.2.5"; in
stdenv.mkDerivation {
  name = "ncftp-${version}";

  src = fetchurl {
    url = "ftp://ftp.ncftp.com/ncftp/ncftp-${version}-src.tar.bz2";
    sha256 = "0hlx12i0lwi99qsrx7nccf4nvwjj2gych4yks5y179b1ax0y5sxl";
  };

  buildInputs = [ ncurses ];

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

  configureFlags = [ "--mandir=$out/share/man/" ];

  meta = with stdenv.lib; {
    description = "Command line FTP (File Transfer Protocol) client";
    homepage = http://www.ncftp.com/ncftp/;
    platforms = platforms.unix;
    maintainers = [ maintainers.bjornfor ];
  };
}
