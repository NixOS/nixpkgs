{ stdenv, fetchFromGitHub, cmake, python, pkgconfig, libxml2, glib, openssl, curl, check, gpgme }:

stdenv.mkDerivation rec {
  version = "1.9.2";
  name = "librepo-${version}";

  src = fetchFromGitHub {
    owner  = "rpm-software-management";
    repo   = "librepo";
    rev    = version;
    sha256 = "0xa9ng9mhpianhjy2a0jnj8ha1zckk2sz91y910daggm1qcv5asx";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  cmakeFlags="-DPYTHON_DESIRED=${stdenv.lib.substring 0 1 python.pythonVersion}";

  buildInputs = [ python libxml2 glib openssl curl check gpgme ];

  # librepo/fastestmirror.h includes curl/curl.h, and pkg-config specfile refers to others in here
  propagatedBuildInputs = [ curl gpgme libxml2 ];

  meta = with stdenv.lib; {
    description = "Library providing C and Python (libcURL like) API for downloading linux repository metadata and packages";
    homepage    = https://rpm-software-management.github.io/librepo/;
    license     = licenses.lgpl2Plus;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ copumpkin ];
  };
}
