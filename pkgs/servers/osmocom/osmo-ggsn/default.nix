{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, libosmocore
}:

let
  inherit (stdenv) isLinux;
in

stdenv.mkDerivation rec {
  pname = "osmo-ggsn";
  version = "1.10.1";

  src = fetchFromGitHub {
    owner = "osmocom";
    repo = "osmo-ggsn";
    rev = version;
    hash = "sha256-j7Szh6lDZY9ji9VAdE3D73R/WBPDo85nVB8hr4HzO7M=";
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
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Osmocom Gateway GPRS Support Node (GGSN), successor of OpenGGSN";
    homepage = "https://osmocom.org/projects/openggsn";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ janik ];
    platforms = lib.platforms.linux;
  };
}
