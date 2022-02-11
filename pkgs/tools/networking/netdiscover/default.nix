{ lib, stdenv, fetchFromGitHub, libpcap, libnet, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "netdiscover";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "netdiscover-scanner";
    repo = pname;
    rev = version;
    sha256 = "13fp9rfr9vh756m5wck76zbcr0296ir52dahzlqdr52ha9vrswbb";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ libpcap libnet ];

  # Running update-oui-database.sh would probably make the build irreproducible

  meta = with lib; {
    description = "A network address discovering tool, developed mainly for those wireless networks without dhcp server, it also works on hub/switched networks";
    homepage = "https://github.com/netdiscover-scanner/netdiscover";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ vdot0x23 ];
    platforms = platforms.unix;
  };
}
