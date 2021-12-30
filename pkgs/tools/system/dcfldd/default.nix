{ lib, stdenv, fetchurl, dcfldd, testVersion }:

stdenv.mkDerivation rec {
  pname = "dcfldd";
  version = "1.3.4-1";

  src = fetchurl {
    url = "mirror://sourceforge/dcfldd/dcfldd-${version}.tar.gz";
    sha256 = "1y6mwsvm75f5jzxsjjk0yhf8xnpmz6y8qvcxfandavx59lc3l57m";
  };

  buildInputs = [ ];

  passthru.tests.version = testVersion { package = dcfldd; };

  meta = with lib; {
    description = "An enhanced version of GNU dd";

    homepage = "http://dcfldd.sourceforge.net/";

    license = licenses.gpl2;

    platforms = platforms.all;
    maintainers = with maintainers; [ qknight ];
  };
}
