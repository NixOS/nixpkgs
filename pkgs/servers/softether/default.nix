{ lib, stdenv, fetchFromGitHub
, openssl, readline, ncurses, zlib
, dataDir ? "/var/lib/softether" }:

stdenv.mkDerivation rec {
  pname = "softether";
  version = "4.42";
  build = "9798";

  src = fetchFromGitHub {
    owner = "SoftEtherVPN";
    repo = "SoftEtherVPN_Stable";
    rev = "v${version}-${build}-rtm";
    sha256 = "uSI5IV/Xhu+jnjVUWbYizTcSiOkG7N8IjQPPUSJby+I=";
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

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "An Open-Source Free Cross-platform Multi-protocol VPN Program";
    homepage = "https://www.softether.org/";
    license = licenses.asl20;
    maintainers = [ maintainers.rick68 ];
    platforms = [ "x86_64-linux" ];
  };
}
