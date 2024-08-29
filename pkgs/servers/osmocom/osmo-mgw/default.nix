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
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "osmocom";
    repo = "osmo-mgw";
    rev = version;
    hash = "sha256-j0BYONYFU/TjYcxgP2b+tIm2ybWW/ta+ePy3LkrCWHA=";
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
    mainProgram = "osmo-mgw";
    homepage = "https://osmocom.org/projects/osmo-mgw";
    license = lib.licenses.agpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
