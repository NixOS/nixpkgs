{ stdenv, fetchFromGitHub, makeBinaryWrapper, unstableGitUpdater, odin, lib }:

stdenv.mkDerivation {
  pname = "ols";
  version = "0-unstable-2024-05-18";

  src = fetchFromGitHub {
    owner = "DanielGavin";
    repo = "ols";
    rev = "b5b6733320bd866b6895cc2f44910f180dda4e0b";
    hash = "sha256-Mok77ioHklE3jeSFT2um1XgrnRuQf0ysDcTo3Fjukmk=";
  };

  passthru.updateScript = unstableGitUpdater {
    hardcodeZeroVersion = true;
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
