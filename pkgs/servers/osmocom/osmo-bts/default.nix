{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, libosmocore
, libosmoabis
, libosmo-netif
}:

let
  inherit (stdenv) isLinux;
in

stdenv.mkDerivation rec {
  pname = "osmo-bts";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "osmocom";
    repo = "osmo-bts";
    rev = version;
    hash = "sha256-RSWXWQn3DAPtThUbthyXrSFSQhHzKaH/m1f6/MCojzM=";
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
