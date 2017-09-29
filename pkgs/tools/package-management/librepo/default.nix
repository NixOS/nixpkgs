{ stdenv, fetchFromGitHub, cmake, python2, pkgconfig, expat, glib, pcre, openssl, curl, check, attr, gpgme }:

stdenv.mkDerivation rec {
  version = "1.7.20";
  name = "librepo-${version}";

  src = fetchFromGitHub {
    owner  = "rpm-software-management";
    repo   = "librepo";
    rev    = name;
    sha256 = "17fgj2wifn2qxmh1p285fbwys0xbvwbnmxsdfvqyr5njpyl2s99h";
  };

  patchPhase = ''
    substituteInPlace librepo/python/python2/CMakeLists.txt \
      --replace ' ''${PYTHON_INSTALL_DIR}' " $out/lib/python2.7/site-packages"
  '';

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ python2 expat glib pcre openssl curl check attr gpgme ];

  # librepo/fastestmirror.h includes curl/curl.h, and pkg-config specfile refers to others in here
  propagatedBuildInputs = [ curl gpgme expat ];

  meta = with stdenv.lib; {
    description = "Library providing C and Python (libcURL like) API for downloading linux repository metadata and packages";
    license     = licenses.lgpl2Plus;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ copumpkin ];
  };
}

