{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, libosmocore
, lksctp-tools
, libosmo-netif
, libasn1c
, libosmo-sccp
, osmo-iuh
, osmo-mgw
}:

let
  inherit (stdenv) isLinux;
in

stdenv.mkDerivation rec {
  pname = "osmo-hnbgw";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "osmocom";
    repo = "osmo-hnbgw";
    rev = version;
    hash = "sha256-OWCAiU4mK57e5gm6QOovwmoFAaCG1d8ZYpkP4isIqvI=";
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
    lksctp-tools
    libosmo-netif
    libasn1c
    libosmo-sccp
    osmo-iuh
    osmo-mgw
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Osmocom Home NodeB Gateway, for attaching femtocells to the 3G CN (OsmoMSC, OsmoSGSN)";
    mainProgram = "osmo-hnbgw";
    homepage = "https://osmocom.org/projects/osmohnbgw";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ janik ];
    platforms = lib.platforms.linux;
  };
}
