{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libconfuse,
  libxcrypt,
  testers,
  merecat,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "merecat";
  version = "2.31";

  # Or, already reconf'd: ftp://ftp.troglobit.com/merecat/merecat-${finalAttrs.version}.tar.xz
  src = fetchFromGitHub {
    owner = "troglobit";
    repo = "merecat";
    rev = "v${finalAttrs.version}";
    hash = "sha256-oIzOXUnCFqd3HPyKp58r+enRRpaE7f9hqNITtxCCB7I=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libconfuse
    libxcrypt
  ];

  passthru.tests = {
    testVersion = testers.testVersion {
      package = merecat;
      command = "merecat -V";
    };
    inherit (nixosTests) merecat;
  };

  meta = with lib; {
    description = "Small and made-easy HTTP/HTTPS server based on Jef Poskanzer's thttpd";
    homepage = "https://troglobit.com/projects/merecat/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
    # Strange header and/or linker errors
    broken = stdenv.isDarwin;
  };
})
