{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, libosmocore
, libosmoabis
, libosmo-netif
, libosmo-sccp
, osmo-mgw
}:

let
  inherit (stdenv) isLinux;
in

stdenv.mkDerivation rec {
  pname = "osmo-bsc";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "osmocom";
    repo = "osmo-bsc";
    rev = version;
    hash = "sha256-9WXK2vw+SvAAaBzhpeB+sBux9cGWyPtJVczRfk4rI6E=";
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
    libosmo-sccp
    osmo-mgw
  ];

  enableParallelBuilding = true;

  meta = {
    description = "GSM Base Station Controller";
    homepage = "https://projects.osmocom.org/projects/osmobsc";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ janik ];
    platforms = lib.platforms.linux;
  };
}
