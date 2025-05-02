{ stdenv, fetchFromGitHub, makeBinaryWrapper, unstableGitUpdater, odin, lib }:

stdenv.mkDerivation {
  pname = "ols";
  version = "0-unstable-2024-04-28";

  src = fetchFromGitHub {
    owner = "DanielGavin";
    repo = "ols";
    rev = "49a63471d91120a23ec86f1621e99155d1be55c2";
    hash = "sha256-fHCSPqeN24QbCzwMCLtvK5YnR0ExveDvXRuWL2nHt8M=";
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
