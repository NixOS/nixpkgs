{ lib, stdenv, fetchFromGitHub, which
, enableStatic ? stdenv.hostPlatform.isStatic
}:

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
  dontAddStaticConfigureFlags = true;
  configurePlatforms = [ ];
  configureFlags = [
    "--ar=${stdenv.cc.targetPrefix}ar"
    (lib.enableFeature enableStatic "static")
    (lib.enableFeature enableStatic "lib-static")
  ];

  doCheck = true;

  checkTarget = "test-full";

  installTargets = [ "install" "install-lib-headers" ]
    ++ lib.optional (!enableStatic) "install-lib-so-link";

  meta = with lib; {
    homepage = "http://rhash.sourceforge.net/";
    description = "Console utility and library for computing and verifying hash sums of files";
    license = licenses.bsd0;
    platforms = platforms.all;
    maintainers = [ maintainers.andrewrk ];
  };
}
