{ stdenv, fetchurl
, openssl, readline, ncurses, zlib
, dataDir ? "/var/lib/softether" }:

let
  os = if stdenv.isLinux then "1"
       else if stdenv.isFreeBSD then "2"
       else if stdenv.isSunOS then "3"
       else if stdenv.isDarwin then "4"
       else if stdenv.isOpenBSD then "5"
       else "";
  cpuBits = if stdenv.is64bit then "2" else "1";

in

stdenv.mkDerivation rec {
  pname = "softether";
  version = "4.25";
  build = "9656";
  compiledDate = "2018.01.15";

  src = fetchurl {
    url = "http://www.softether-download.com/files/softether/v${version}-${build}-rtm-${compiledDate}-tree/Source_Code/softether-src-v${version}-${build}-rtm.tar.gz";
    sha256 = "1y1m8lf0xfh7m70d15wj2jjf5a5qhi3j49ciwqmsscsqvb1xwimr";
  };

  buildInputs = [ openssl readline ncurses zlib ];

  preConfigure = ''
      echo "${os}
      ${cpuBits}
      " | ./configure
      rm configure
  '';

  buildPhase = ''
      mkdir -p $out/bin
      sed -i \
          -e "/INSTALL_BINDIR=/s|/usr/bin|/bin|g" \
          -e "/_DIR=/s|/usr|${dataDir}|g" \
          -e "s|\$(INSTALL|$out/\$(INSTALL|g" \
          -e "/echo/s|echo $out/|echo |g" \
          Makefile
  '';

  meta = with stdenv.lib; {
    description = "An Open-Source Free Cross-platform Multi-protocol VPN Program";
    homepage = https://www.softether.org/;
    license = licenses.gpl2;
    maintainers = [ maintainers.rick68 ];
    platforms = [ "x86_64-linux" ];
  };
}
