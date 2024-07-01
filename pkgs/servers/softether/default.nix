{ lib, stdenv, fetchFromGitHub
, openssl, readline, ncurses, zlib, libpcap, libiconv
, dataDir ? "/var/lib/softether"
, removeRegionLock ? false }:

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

  patches = lib.optionals removeRegionLock [
    # https://github.com/SoftEtherVPN/SoftEtherVPN/blob/5f12684b42f747c2d15f3b89a03133c15dd902ea/src/Cedar/Server.c#L10586-L10637
    ./remove-region-lock.patch
  ];

  buildInputs = [ openssl readline ncurses zlib ] ++ lib.optionals stdenv.isDarwin [ libpcap libiconv ];

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
    description = "Open-Source Free Cross-platform Multi-protocol VPN Program";
    homepage = "https://www.softether.org/";
    license = licenses.asl20;
    maintainers = [ maintainers.rick68 ];
    platforms = intersectLists (platforms.linux ++ platforms.freebsd ++ platforms.darwin ++ platforms.openbsd) (platforms.x86 ++ platforms.arm ++ platforms.aarch64 ++ platforms.mips ++ platforms.power);
    broken = stdenv.isDarwin;
  };
}
