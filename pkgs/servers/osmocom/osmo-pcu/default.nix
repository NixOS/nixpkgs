{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, libosmocore
,
}:

let
  inherit (stdenv) isLinux;
in

stdenv.mkDerivation rec {
  pname = "osmo-pcu";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "osmocom";
    repo = "osmo-pcu";
    rev = version;
    hash = "sha256-p5gBOHw/3NJ482EX5LcmaWkwz/ikcK7EEeio/puNTFo=";
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
    description = "Osmocom Packet control Unit (PCU): Network-side GPRS (RLC/MAC); BTS- or BSC-colocated";
    homepage = "https://osmocom.org/projects/osmopcu";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ janik ];
    platforms = lib.platforms.linux;
  };
}
