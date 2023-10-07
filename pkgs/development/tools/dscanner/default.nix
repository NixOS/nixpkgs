{ lib, stdenv, ldc, fetchFromGitHub }:

let
  dscannerVersion = "0.15.2";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "dscanner";
  version = dscannerVersion;

  src = fetchFromGitHub {
    owner = "dlang-community";
    repo = "d-scanner";
    rev = "v${dscannerVersion}";
    hash = "sha256-TJ3aoU4q0lJdaL85LhuEJcYyZ7wOpGBwwmSz/bKnh9M=";
    fetchSubmodules = true;
  };

  patches = [ ./makefile.diff ];

  nativeBuildInputs = [ ldc ];

  configurePhase = ''
    runHook preConfigure
    mkdir -p bin
    printf "%s" "${dscannerVersion}" >bin/githash.txt
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    make DC=ldc2
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp bin/dscanner $out/bin
    runHook postInstall
  '';

  meta = with lib; {
    description = "Swiss-army knife for D source code";
    homepage = "https://github.com/dlang-community/d-scanner";
    license = licenses.boost;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jtbx ];
  };
})
