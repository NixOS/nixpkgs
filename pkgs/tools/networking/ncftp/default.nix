{ stdenv, fetchurl, ncurses, coreutils }:

let version = "3.2.6"; in
stdenv.mkDerivation {
  name = "ncftp-${version}";

  src = fetchurl {
    url = "ftp://ftp.ncftp.com/ncftp/ncftp-${version}-src.tar.xz";
    sha256 = "1389657cwgw5a3kljnqmhvfh4vr2gcr71dwz1mlhf22xq23hc82z";
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
