{ stdenv, fetchFromGitHub, makeBinaryWrapper, odin, lib }:

stdenv.mkDerivation {
  pname = "ols";
  version = "0-unstable-2024-02-09";

  src = fetchFromGitHub {
    owner = "DanielGavin";
    repo = "ols";
    rev = "3eb1e0e60a66a4fc7347fb77837ff45ccbe1cabb";
    hash = "sha256-qPcSZjvlBmFf3M98GrwIu8SGO2VbgdqBKzyFpGSEtrI=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  buildInputs = [
    odin
  ];

  postPatch = ''
    patchShebangs build.sh
  '';

  buildPhase = ''
    runHook preBuild

    ./build.sh

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 ols -t $out/bin/
    wrapProgram $out/bin/ols --set-default ODIN_ROOT ${odin}/share

    runHook postInstall
  '';

  meta = with lib; {
    inherit (odin.meta) platforms;
    description = "Language server for the Odin programming language";
    mainProgram = "ols";
    homepage = "https://github.com/DanielGavin/ols";
    license = licenses.mit;
    maintainers = with maintainers; [ astavie znaniye ];
  };
}
