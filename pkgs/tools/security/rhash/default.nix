{ lib
, stdenv
, fetchFromGitHub
, which
, enableStatic ? stdenv.hostPlatform.isStatic
}:

stdenv.mkDerivation rec {
  version = "1.4.3";
  pname = "rhash";

  src = fetchFromGitHub {
    owner = "rhash";
    repo = "RHash";
    rev = "v${version}";
    sha256 = "sha256-R+dHYG0DBI1uo+yF/pxoTv/V9WSfph043bH6erZjeCE=";
  };

  nativeBuildInputs = [ which ];

  # configure script is not autotools-based, doesn't support these options
  dontAddStaticConfigureFlags = true;

  configurePlatforms = [ ];

  configureFlags = [
    "--ar=${stdenv.cc.targetPrefix}ar"
    "--target=${stdenv.hostPlatform.config}"
    (lib.enableFeature enableStatic "static")
    (lib.enableFeature enableStatic "lib-static")
  ];

  doCheck = true;

  checkTarget = "test-full";

  installTargets = [
    "install"
    "install-lib-headers"
  ] ++ lib.optionals (!enableStatic) [
    "install-lib-so-link"
  ];

  meta = with lib; {
    homepage = "http://rhash.sourceforge.net/";
    description = "Console utility and library for computing and verifying hash sums of files";
    license = licenses.bsd0;
    platforms = platforms.all;
    maintainers = with maintainers; [ andrewrk ];
  };
}
