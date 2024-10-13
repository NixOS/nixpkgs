{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, libosmocore
, lksctp-tools
, libosmo-netif
, libosmo-sccp
, libasn1c
, python3
}:

let
  inherit (stdenv.hostPlatform) isLinux;
in

stdenv.mkDerivation rec {
  pname = "osmo-iuh";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "osmocom";
    repo = "osmo-iuh";
    rev = version;
    hash = "sha256-1G5N74N3BH+XP4hr+w0a1wc2DaE/GXpSu3JiPo8UBhI=";
  };

  prePatch = ''
    substituteInPlace src/../asn1/utils/asn1tostruct.py  \
      --replace '#!/usr/bin/env python3' '#!${python3}/bin/python3'
  '';

  postPatch = ''
    echo "${version}" > .tarball-version
  '';


  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    python3
  ];

  buildInputs = [
    libosmocore
    lksctp-tools
    libosmo-netif
    libosmo-sccp
    libasn1c
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Osmocom IuH library";
    homepage = "https://osmocom.org/projects/osmohnbgw/wiki";
    license = lib.licenses.agpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
