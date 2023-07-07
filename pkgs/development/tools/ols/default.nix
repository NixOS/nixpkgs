{ stdenv, fetchFromGitHub, makeBinaryWrapper, odin, lib }:

stdenv.mkDerivation {
  pname = "ols";
  version = "nightly-2023-05-18";

  src = fetchFromGitHub {
    owner = "DanielGavin";
    repo = "ols";
    rev = "fd136199897d5e5c87f6f1fbfd076ed18e41d7b7";
    hash = "sha256-lRoDSc2bZSuXTam3Q5OOlSD6YAobCFKNRbtQ41Qx5EY=";
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
    maintainers = with maintainers; [ astavie ];
    platforms = odin.meta.platforms;
  };
}
