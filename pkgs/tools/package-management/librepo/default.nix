{ stdenv, fetchFromGitHub, cmake, python2, pkgconfig, expat, glib, pcre, openssl, curl, check, attr, gpgme }:

stdenv.mkDerivation rec {
  version = "1.8.1";
  name = "librepo-${version}";

  src = fetchFromGitHub {
    owner  = "rpm-software-management";
    repo   = "librepo";
    rev    = version;
    sha256 = "11rypnxjgsc2klyg294ndxy1cyp0nyk00zpjhcvqkhp58vvkkv12";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ python2 expat glib pcre openssl curl check attr gpgme ];

  # librepo/fastestmirror.h includes curl/curl.h, and pkg-config specfile refers to others in here
  propagatedBuildInputs = [ curl gpgme expat ];

  meta = with stdenv.lib; {
    description = "Library providing C and Python (libcURL like) API for downloading linux repository metadata and packages";
    homepage    = https://rpm-software-management.github.io/librepo/;
    license     = licenses.lgpl2Plus;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ copumpkin ];
  };
}
