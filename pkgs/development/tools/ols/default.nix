{ stdenv, fetchFromGitHub, makeBinaryWrapper, odin, lib }:

stdenv.mkDerivation {
  pname = "ols";
  version = "nightly-2023-07-09";

  src = fetchFromGitHub {
    owner = "DanielGavin";
    repo = "ols";
    rev = "255ad5958026dc3a3116f621eaebd501b8b26a22";
    hash = "sha256-XtlIZToNvmU4GhUJAxuVmKvKwnPebaxjv7jp/AgE/uM=";
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
