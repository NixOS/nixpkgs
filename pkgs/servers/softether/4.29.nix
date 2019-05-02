{ stdenv, fetchurl
, openssl, readline, ncurses, zlib
, dataDir ? "/var/lib/softether" }:

stdenv.mkDerivation rec {
  name = "softether-${version}";
  version = "4.29";
  build = "9680";

  src = fetchurl {
    url = "https://github.com/SoftEtherVPN/SoftEtherVPN_Stable/releases/download/v${version}-${build}-rtm/softether-src-v${version}-${build}-rtm.tar.gz";
    sha256 = "1r169s5dr31060r2mxkmm08riy6zrxgapmrc6kdrpxdav6kmy0z6";
  };

  buildInputs = [ openssl readline ncurses zlib ];

  preConfigure = ''
      ./configure
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
    license = licenses.asl20;
    maintainers = [ maintainers.rick68 ];
    platforms = [ "x86_64-linux" ];
  };
}
