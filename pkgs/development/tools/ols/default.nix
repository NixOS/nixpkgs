{ stdenv, fetchFromGitHub, makeBinaryWrapper, unstableGitUpdater, odin, lib }:

stdenv.mkDerivation {
  pname = "ols";
  version = "0-unstable-2024-05-22";

  src = fetchFromGitHub {
    owner = "DanielGavin";
    repo = "ols";
    rev = "a2f333bfbdd187aa7463ae230f7a617f6bccb611";
    hash = "sha256-sM8UkfuzQib0L8mUhmtVZAjbZKA07aY2YLvooj3zdc0=";
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
