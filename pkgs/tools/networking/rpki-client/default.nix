{ lib, stdenv, fetchurl, autoreconfHook, expat, libressl, rsync }:

stdenv.mkDerivation rec {
  pname = "rpki-client";
  version = "8.0";

  src = fetchurl {
    url = "https://cdn.openbsd.org/pub/OpenBSD/${pname}/${pname}-${version}.tar.gz";
    hash = "sha256-W3EMzuLn6UlYflTa+COBFnEXSlDGcXRuWidq+qDOVb4=";
  };

  propagatedBuildInputs = [
    expat
    libressl
    rsync
  ];

  nativeBuildInputs = [
    autoreconfHook
  ];

  configureFlags = [
    "--with-output-dir=/var/lib/rpki-client"
    "--localstatedir=/var"
  ];

  meta = with lib; {
    description = "The OpenBSD RPKI Validator";
    homepage = "https://www.openbsd.org/rpki-client/portable.html";
    license = licenses.isc;
    maintainers = with maintainers; [ vidister ];
    platforms = with platforms; unix;
  };
}
