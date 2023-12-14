{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, libosmocore
, libosmo-netif
, libosmoabis
}:

let
  inherit (stdenv) isLinux;
in

stdenv.mkDerivation rec {
  pname = "osmo-mgw";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "osmocom";
    repo = "osmo-mgw";
    rev = version;
    hash = "sha256-vsOaWlO6y6qV1XcH/jNjvFzApIHqNrPDzZtDoTIMA5k=";
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
    libosmo-netif
    libosmoabis
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Osmocom Media Gateway (MGW). speaks RTP and E1 as well as MGCP";
    homepage = "https://osmocom.org/projects/osmo-mgw";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ janik ];
    platforms = lib.platforms.linux;
  };
}
