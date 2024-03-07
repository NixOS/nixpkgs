{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, libosmocore
, sqlite
, libosmoabis
, libosmo-netif
, libosmo-sccp
, osmo-mgw
, osmo-hlr
, lksctp-tools
}:

let
  inherit (stdenv) isLinux;
in

stdenv.mkDerivation rec {
  pname = "osmo-msc";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "osmocom";
    repo = "osmo-msc";
    rev = version;
    hash = "sha256-e36k/uEajtQ3cnqn+xvPQPGWuA8ILIlkjOkd96IOvow=";
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
    sqlite
    libosmoabis
    libosmo-netif
    libosmo-sccp
    osmo-mgw
    osmo-hlr
    lksctp-tools
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Osmocom implementation of 3GPP Mobile Swtiching Centre (MSC)";
    homepage = "https://osmocom.org/projects/osmomsc/wiki";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ janik ];
    platforms = lib.platforms.linux;
  };
}
