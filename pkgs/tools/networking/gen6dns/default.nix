{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "gen6dns";
  version = "1.3";

  src = fetchurl {
    url = "https://www.hznet.de/tools/gen6dns-${version}.tar.gz";
    hash = "sha256-MhYfgzbGPmrhPx89EpObrEkxaII7uz4TbWXeEGF7Xws=";
  };

  preInstall = ''
    mkdir -p $out/bin
  '';

  makeFlags = [ "INSTALL_DIR=$(out)/bin" ];

  meta = with lib; {
    description = "Tool to generate static DNS records (AAAA and PTR) for hosts using Stateless Address Autoconfig (SLAAC)";
    homepage = "https://www.hznet.de/tools.html#gen6dns";
    license = licenses.bsd3;
    maintainers = with maintainers; [ majiir ];
    platforms = platforms.unix;
  };
}
