{ lib, stdenv, fetchFromGitHub, libpcap, libnet, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "netdiscover";
  version = "0.9";

  src = fetchFromGitHub {
    owner = "netdiscover-scanner";
    repo = pname;
    rev = version;
    sha256 = "sha256-4pSGWMTOMECXKpba5739OQA8FIuNmffFbniU9Gd4GlM=";
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
