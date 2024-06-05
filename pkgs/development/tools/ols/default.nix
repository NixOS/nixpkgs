{ stdenv, fetchFromGitHub, makeBinaryWrapper, unstableGitUpdater, odin, lib }:

stdenv.mkDerivation {
  pname = "ols";
  version = "0-unstable-2024-06-04";

  src = fetchFromGitHub {
    owner = "DanielGavin";
    repo = "ols";
    rev = "5805fd0b688446eeb23528497972b9f934208f1a";
    hash = "sha256-zvojGIxMGawddWx5vnBQMTybz+jL9LXfaShbof7wwq0=";
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
