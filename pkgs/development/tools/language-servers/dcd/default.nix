{ lib, stdenv, ldc, fetchFromGitHub }:

let
  dcdVersion = "0.15.2";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "dcd";
  version = dcdVersion;

  src = fetchFromGitHub {
    owner = "dlang-community";
    repo = "dcd";
    rev = "v${dcdVersion}";
    hash = "sha256-c5PAUjS2+DvY1QfI+whu0bqFQl0wDUzUUtfHjRFoieA=";
    fetchSubmodules = true;
  };

  patches = [ ./makefile.diff ];

  nativeBuildInputs = [ ldc ];

  configurePhase = ''
    runHook preConfigure
    mkdir -p bin
    printf "%s" "${dcdVersion}" >bin/githash.txt
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    make ldc
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp bin/{dcd-client,dcd-server} $out/bin
    runHook postInstall
  '';

  meta = with lib; {
    description = "Language server for the D programming language";
    homepage = "https://github.com/dlang-community/DCD";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jtbx ];
  };
})
