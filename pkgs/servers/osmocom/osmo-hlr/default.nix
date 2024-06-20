{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, libosmocore
, libosmoabis
, sqlite
}:

let
  inherit (stdenv) isLinux;
in

stdenv.mkDerivation rec {
  pname = "osmo-hlr";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "osmocom";
    repo = "osmo-hlr";
    rev = version;
    hash = "sha256-snl4Ezvz28NJEjHwb68V+W3MvMJjkFvc/AlGaeSyiXc=";
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
    sqlite
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Osmocom implementation of 3GPP Home Location Registr (HLR)";
    homepage = "https://osmocom.org/projects/osmo-hlr";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ janik ];
    platforms = lib.platforms.linux;
    mainProgram = "osmo-hlr";
  };
}
