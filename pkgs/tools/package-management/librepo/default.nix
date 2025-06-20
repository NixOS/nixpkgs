{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  python3,
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
  version = "1.20.0";
  pname = "librepo";

  outputs = [
    "out"
    "dev"
    "py"
  ];

  src = fetchFromGitHub {
    owner = "rpm-software-management";
    repo = "librepo";
    tag = version;
    hash = "sha256-KYBHImdGQgf/IZ5FMhzrbBTeZF76AIP3RjVPT3w0oT8=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    doxygen
  ];

  buildInputs = [
    python3
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

  cmakeFlags = [ "-DPYTHON_DESIRED=${lib.substring 0 1 python3.pythonVersion}" ];

  postFixup = ''
    moveToOutput "lib/${python3.libPrefix}" "$py"
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Library providing C and Python (libcURL like) API for downloading linux repository metadata and packages";
    homepage = "https://rpm-software-management.github.io/librepo/";
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
