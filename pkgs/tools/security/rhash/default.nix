{ stdenv, fetchFromGitHub, which }:

stdenv.mkDerivation rec {
  version = "1.4.0";
  pname = "rhash";

  src = fetchFromGitHub {
    owner = "rhash";
    repo = "RHash";
    rev = "v${version}";
    sha256 = "18zgr1bjzz8v6rckz2q2hx9f2ssbv8qfwclzpbyjaz0c1c9lqqar";
  };

  nativeBuildInputs = [ which ];

  # configure script is not autotools-based, doesn't support these options
  configurePlatforms = [ ];

  doCheck = true;

  checkTarget = "test-full";

  installTargets = [ "install" "install-lib-shared" "install-lib-so-link" "install-lib-headers" ];

  meta = with stdenv.lib; {
    homepage = "http://rhash.sourceforge.net/";
    description = "Console utility and library for computing and verifying hash sums of files";
    license = licenses.bsd0;
    platforms = platforms.all;
    maintainers = [ maintainers.andrewrk ];
  };
}
