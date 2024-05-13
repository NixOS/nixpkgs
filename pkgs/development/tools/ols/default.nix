{ stdenv, fetchFromGitHub, makeBinaryWrapper, unstableGitUpdater, odin, lib }:

stdenv.mkDerivation {
  pname = "ols";
  version = "0-unstable-2024-05-06";

  src = fetchFromGitHub {
    owner = "DanielGavin";
    repo = "ols";
    rev = "5c646656e988ddcdaee09f1bea666dc00ea2ea4d";
    hash = "sha256-W8D+szu4+mDYwDLWvGRL3ICZ9Dr93pFweEO2+0awHfo=";
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
