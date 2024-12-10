{
  stdenv,
  fetchFromGitHub,
  makeBinaryWrapper,
  unstableGitUpdater,
  odin,
  lib,
}:

stdenv.mkDerivation {
  pname = "ols";
  version = "0-unstable-2024-05-11";

  src = fetchFromGitHub {
    owner = "DanielGavin";
    repo = "ols";
    rev = "30625d5568c085c622deece91ed8ac9e81ba28be";
    hash = "sha256-iBrXpLrnBL5W47Iz0Uy4nd5h/ADqSnxZt2jWQi9eYiM=";
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
    maintainers = with maintainers; [
      astavie
      znaniye
    ];
  };
}
