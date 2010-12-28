{stdenv, fetchurl, ncurses, coreutils}:

let version = "3.2.4"; in
stdenv.mkDerivation {
  name = "ncftp-${version}";

  src = fetchurl {
    # `ncftp.com' got stolen, apparently, so resort to Debian.
    url = "mirror://debian/pool/main/n/ncftp/ncftp_${version}.orig.tar.gz";
    sha256 = "6f26e7891f3eab27eebd2bbbe2bc87d5ae872e610eaf0bc5652aec520adcf68a";
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

    # Homeless!
    # homepage = http://www.ncftp.com/ncftp/;
  };
}
