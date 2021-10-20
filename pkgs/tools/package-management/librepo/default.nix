{ lib, stdenv
, fetchFromGitHub
, cmake
, python
, pkg-config
, libxml2
, glib
, openssl
, zchunk
, curl
, check
, gpgme
}:

stdenv.mkDerivation rec {
  version = "1.14.2";
  pname = "librepo";

  outputs = [ "out" "dev" "py" ];

  src = fetchFromGitHub {
    owner = "rpm-software-management";
    repo = "librepo";
    rev = version;
    sha256 = "sha256-KpGbHBgywaXV7r8W5CPS2N1GohdDFiOwAJmrrjS1m5g=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
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

  meta = with lib; {
    description = "Library providing C and Python (libcURL like) API for downloading linux repository metadata and packages";
    homepage = "https://rpm-software-management.github.io/librepo/";
    license = licenses.lgpl2Plus;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ copumpkin ];
  };
}
