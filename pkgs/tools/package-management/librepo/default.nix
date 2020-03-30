{ stdenv
, fetchFromGitHub
, cmake
, python
, pkgconfig
, libxml2
, glib
, openssl
, zchunk
, curl
, check
, gpgme
}:

stdenv.mkDerivation rec {
  version = "1.11.3";
  pname = "librepo";

  outputs = [ "out" "dev" "py" ];

  src = fetchFromGitHub {
    owner = "rpm-software-management";
    repo = "librepo";
    rev = version;
    sha256 = "1kdv0xyrbd942if82yvm9ykcskziq2xhw5cpb3xv4wx32a9kc8yz";
  };

  nativeBuildInputs = [
    cmake
    pkgconfig
  ];

  buildInputs = [
    python
    libxml2
    glib
    openssl
    zchunk
    curl
    check
    gpgme
  ];

  # librepo/fastestmirror.h includes curl/curl.h, and pkg-config specfile refers to others in here
  propagatedBuildInputs = [
    curl
    gpgme
    libxml2
  ];

  cmakeFlags = [
    "-DPYTHON_DESIRED=${stdenv.lib.substring 0 1 python.pythonVersion}"
  ];

  postFixup = ''
    moveToOutput "lib/${python.libPrefix}" "$py"
  '';

  meta = with stdenv.lib; {
    description = "Library providing C and Python (libcURL like) API for downloading linux repository metadata and packages";
    homepage = "https://rpm-software-management.github.io/librepo/";
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ copumpkin ];
  };
}
