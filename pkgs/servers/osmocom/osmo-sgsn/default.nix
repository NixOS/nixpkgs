{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, libosmocore
, libosmoabis
, libosmo-netif
, osmo-hlr
, osmo-ggsn
, c-ares
}:

let
  inherit (stdenv) isLinux;
in

stdenv.mkDerivation rec {
  pname = "osmo-sgsn";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "osmocom";
    repo = "osmo-sgsn";
    rev = version;
    hash = "sha256-7roXf5+jZNtx9ZfPYIs5kojiTIHsGGh180cc7uv6hdk=";
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
    osmo-hlr
    osmo-ggsn
    c-ares
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Osmocom implementation of the 3GPP Serving GPRS Support Node (SGSN)";
    homepage = "https://osmocom.org/projects/osmosgsn";
    license = lib.licenses.agpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "osmo-sgsn";
  };
}
