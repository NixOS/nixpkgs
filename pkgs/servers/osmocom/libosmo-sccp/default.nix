{ lib
, stdenv
, autoreconfHook
, fetchFromGitHub
, lksctp-tools
, pkg-config
, libosmocore
, libosmo-netif
}:

stdenv.mkDerivation rec {
  pname = "libosmo-sccp";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "osmocom";
    repo = "libosmo-sccp";
    rev = version;
    hash = "sha256-ScJZke9iNmFc9XXqtRjb24ZzKfa5EYws5PDNhcZFb7U=";
  };

  configureFlags = [ "--with-systemdsystemunitdir=$out" ];

  postPatch = ''
    echo "${version}" > .tarball-version
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    lksctp-tools
    libosmocore
    libosmo-netif
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "SCCP + SIGTRAN (SUA/M3UA) libraries as well as OsmoSTP";
    homepage = "https://osmocom.org/projects/libosmo-sccp";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      janik
      markuskowa
    ];
  };
}
