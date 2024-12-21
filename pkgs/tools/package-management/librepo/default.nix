{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  python,
  pkg-config,
  libxml2,
  glib,
  openssl,
  zchunk,
  curl,
  check,
  gpgme,
  libselinux,
  nix-update-script,
  doxygen,
}:

stdenv.mkDerivation rec {
  version = "1.19.0";
  pname = "librepo";

  outputs = [
    "out"
    "dev"
    "py"
  ];

  src = fetchFromGitHub {
    owner = "rpm-software-management";
    repo = "librepo";
    rev = version;
    sha256 = "sha256-ws57vFoK5yBMHHNQ9W48Icp4am0/5k3n4ybem1aAzVM=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    doxygen
  ];

  buildInputs = [
    python
    libxml2
    glib
    openssl
    curl
    check
    gpgme
    zchunk
    libselinux
  ];

  # librepo/fastestmirror.h includes curl/curl.h, and pkg-config specfile refers to others in here
  propagatedBuildInputs = [
    curl
    gpgme
    libxml2
  ];

  cmakeFlags = [ "-DPYTHON_DESIRED=${lib.substring 0 1 python.pythonVersion}" ];

  postFixup = ''
    moveToOutput "lib/${python.libPrefix}" "$py"
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Library providing C and Python (libcURL like) API for downloading linux repository metadata and packages";
    homepage = "https://rpm-software-management.github.io/librepo/";
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ copumpkin ];
  };
}
