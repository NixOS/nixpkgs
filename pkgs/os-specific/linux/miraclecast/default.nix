{ lib, stdenv, fetchFromGitHub, meson, ninja, pkg-config
, glib, readline, pcre, systemd, udev, iproute2 }:

stdenv.mkDerivation {
  pname = "miraclecast";
  version = "1.0-20231112";

  src = fetchFromGitHub {
    owner  = "albfan";
    repo   = "miraclecast";
    rev    = "af6ab257eae83bb0270a776a8fe00c0148bc53c4";
    hash   = "sha256-3ZIAvA3w/ZhoJtVmUD444nch0PGD58PdBRke7zd9IuQ=";
  };

  nativeBuildInputs = [ meson ninja pkg-config ];

  buildInputs = [ glib pcre readline systemd udev iproute2 ];

  mesonFlags = [
    "-Drely-udev=true"
    "-Dbuild-tests=true"
    "-Dip-binary=${iproute2}/bin/ip"
  ];

  meta = with lib; {
    description = "Connect external monitors via Wi-Fi";
    homepage    = "https://github.com/albfan/miraclecast";
    license     = licenses.lgpl21Plus;
    maintainers = with maintainers; [ ];
    platforms   = platforms.linux;
  };
}
