{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, libosmocore
, sofia_sip
, glib
}:

let
  inherit (stdenv) isLinux;
in

stdenv.mkDerivation rec {
  pname = "osmo-sip-connector";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "osmocom";
    repo = "osmo-sip-connector";
    rev = version;
    hash = "sha256-vsPtNeh6Yi5fQb+E90OF4/Hnjl9T5nMf9EMBhzpIA2I=";
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
    homepage = "https://osmocom.org/projects/osmo-sip-conector";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ janik ];
    platforms = lib.platforms.linux;
  };
}
