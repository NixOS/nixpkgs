{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libosmocore,
  lksctp-tools,
  libasn1c,
  libosmoabis,
  libosmo-netif,
  libosmo-sccp,
  osmo-iuh,
}:

let
  inherit (stdenv) isLinux;
in

stdenv.mkDerivation rec {
  pname = "osmo-hnodeb";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "osmocom";
    repo = "osmo-hnodeb";
    rev = version;
    hash = "sha256-Izivyw2HqRmrM68ehGqlIkJeuZ986d1WQ0yr6NWWTdA=";
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
    libasn1c
    libosmoabis
    libosmo-netif
    libosmo-sccp
    osmo-iuh
  ];

  enableParallelBuilding = true;

  meta = {
    description = "(upper layers of) HomeNodeB";
    mainProgram = "osmo-hnodeb";
    homepage = "https://osmocom.org/projects/osmo-hnodeb";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ janik ];
    platforms = lib.platforms.linux;
  };
}
