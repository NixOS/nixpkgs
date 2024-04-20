{ stdenv, fetchFromGitHub, makeBinaryWrapper, odin, lib }:

stdenv.mkDerivation {
  pname = "ols";
  version = "0-unstable-2024-04-15";

  src = fetchFromGitHub {
    owner = "DanielGavin";
    repo = "ols";
    rev = "aa1aabda1cce68a6038c48429cc759f09ad2ebab";
    hash = "sha256-yM+Syx8hWiSZatWfFFGz8lUJTOCozkZWPdPUhRW0/Ow=";
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
