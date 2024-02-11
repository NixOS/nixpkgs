{ stdenv, fetchFromGitHub, makeBinaryWrapper, odin, lib }:

stdenv.mkDerivation {
  pname = "ols";
  version = "nightly-2024-02-10";

  src = fetchFromGitHub {
    owner = "DanielGavin";
    repo = "ols";
    rev = "7145764020fa463ee393b1f2701b1c151c162cce";
    hash = "sha256-lhFiSGArklebVbZ14WHexGDM2jqkM32y/kMHniFIXfE=";
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

    mkdir -p $out/bin
    cp ols $out/bin
    wrapProgram $out/bin/ols --set-default ODIN_ROOT ${odin}/share

    runHook postInstall
  '';

  meta = with lib; {
    description = "Language server for the Odin programming language";
    homepage = "https://github.com/DanielGavin/ols";
    license = licenses.mit;
    maintainers = with maintainers; [ astavie znaniye ];
    platforms = odin.meta.platforms;
  };
}
