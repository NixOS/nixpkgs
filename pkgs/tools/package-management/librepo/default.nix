{ stdenv, fetchFromGitHub, cmake, python, pkgconfig, expat, glib, pcre, openssl, curl, check, attr, gpgme }:

stdenv.mkDerivation rec {
  version = "1.7.18";
  name = "librepo-${version}";

  src = fetchFromGitHub {
    owner  = "rpm-software-management";
    repo   = "librepo";
    rev    = name;
    sha256 = "05iqx2kvfqsskb2r3n5p8f91i4gd4pbw6nh30pn532mgab64cvxk";
  };

  patchPhase = ''
    substituteInPlace librepo/python/python2/CMakeLists.txt \
      --replace ' ''${PYTHON_INSTALL_DIR}' " $out/lib/python2.7/site-packages"
  '';

  buildInputs = [ cmake python pkgconfig expat glib pcre openssl curl check attr gpgme ];

  # librepo/fastestmirror.h includes curl/curl.h, and pkg-config specfile refers to others in here
  propagatedBuildInputs = [ curl gpgme expat ];
}

