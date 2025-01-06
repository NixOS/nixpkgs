{ lib
, stdenv
, autoreconfHook
, fetchFromGitHub
, lksctp-tools
, pkg-config
, libosmocore
}:

stdenv.mkDerivation rec {
  pname = "libosmo-netif";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "osmocom";
    repo = "libosmo-netif";
    rev = version;
    hash = "sha256-C8lIURQmu15RQij7c09+F/c8XSzTcgHt4MkgdkqTa3Q=";
  };

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
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Osmocom network / socket interface library";
    homepage = "https://osmocom.org/projects/libosmo-netif/wiki";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      markuskowa
    ];
  };
}
