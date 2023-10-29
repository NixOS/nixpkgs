{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, libosmocore
, libosmoabis
, libosmo-netif
}:

stdenv.mkDerivation rec {
  pname = "osmo-bts";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "osmocom";
    repo = "osmo-bts";
    rev = version;
    hash = "sha256-Y972aa98bNU3IhuGMV80nh4ZjQKUdK6of1Q8H75Ips8=";
  };

  postPatch = ''
    echo "${version}" > .tarball-version
  '';


  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libosmocore
    libosmoabis
    libosmo-netif
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Osmocom GSM Base Transceiver Station (BTS)";
    homepage = "https://osmocom.org/projects/osmobts";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ janik ];
    platforms = lib.platforms.linux;
  };
}
