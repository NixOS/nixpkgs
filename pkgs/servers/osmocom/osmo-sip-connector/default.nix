{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libosmocore,
  sofia_sip,
  glib,
}:

let
  inherit (stdenv) isLinux;
in

stdenv.mkDerivation rec {
  pname = "osmo-sip-connector";
  version = "1.6.3";

  src = fetchFromGitHub {
    owner = "osmocom";
    repo = "osmo-sip-connector";
    rev = version;
    hash = "sha256-5+bNqdQuobCwy99BLTIWLLNIpirMcb8w1xnIew5a9WE=";
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
    sofia_sip
    glib
  ];

  enableParallelBuilding = true;

  meta = {
    description = "This implements an interface between the MNCC (Mobile Network Call Control) interface of OsmoMSC (and also previously OsmoNITB) and SIP";
    mainProgram = "osmo-sip-connector";
    homepage = "https://osmocom.org/projects/osmo-sip-conector";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ janik ];
    platforms = lib.platforms.linux;
  };
}
