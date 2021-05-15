{ lib, stdenv, fetchFromGitHub, which }:

stdenv.mkDerivation rec {
  version = "1.4.1";
  pname = "rhash";

  src = fetchFromGitHub {
    owner = "rhash";
    repo = "RHash";
    rev = "v${version}";
    sha256 = "sha256-kmi1FtJYPBUdMfJlzEsQkTwcYB99isP3yzH1EYlk54g=";
  };

  nativeBuildInputs = [ which ];

  # configure script is not autotools-based, doesn't support these options
  configurePlatforms = [ ];

  doCheck = true;

  checkTarget = "test-full";

  installTargets = [ "install" "install-lib-shared" "install-lib-so-link" "install-lib-headers" ];

  meta = with lib; {
    homepage = "http://rhash.sourceforge.net/";
    description = "Console utility and library for computing and verifying hash sums of files";
    license = licenses.bsd0;
    platforms = platforms.all;
    maintainers = [ maintainers.andrewrk ];
  };
}
