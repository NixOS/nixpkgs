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
  version = "1.11.1";

  src = fetchFromGitHub {
    owner = "osmocom";
    repo = "osmo-sgsn";
    rev = version;
    hash = "sha256-obslARttKN+ut1ubIQ7zsL3/mnXK/AUoJeBnRJoPoZ0=";
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
    maintainers = with lib.maintainers; [ janik ];
    platforms = lib.platforms.linux;
    mainProgram = "osmo-sgsn";
  };
}
