{ lib
, stdenv
, autoreconfHook
, fetchFromGitHub
, pkg-config
, libosmocore
, ortp
, bctoolbox
}:

stdenv.mkDerivation rec {
  pname = "libosmoabis";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "osmocom";
    repo = "libosmo-abis";
    rev = version;
    hash = "sha256-B3M6sqFPecMR4/uiJ93C5ZWlq9IVpQwXCu9GZ4twHJw=";
  };

  configureFlags = [ "enable_dahdi=false" ];

  postPatch = ''
    echo "${version}" > .tarball-version
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libosmocore
    ortp
    bctoolbox
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Osmocom Abis interface library";
    homepage = "https://github.com/osmocom/libosmo-abis";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      markuskowa
    ];
  };
}
