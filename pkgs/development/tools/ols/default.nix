{ stdenv, fetchFromGitHub, makeBinaryWrapper, odin, lib }:

stdenv.mkDerivation {
  pname = "ols";
  version = "nightly-2023-11-04";

  src = fetchFromGitHub {
    owner = "DanielGavin";
    repo = "ols";
    rev = "b19c24eb17e7c16bcfb3144665fd405fd5e580f3";
    hash = "sha256-c8mHVdXbn7aRKI/QBIZvBvl4sCNK49q+crQmTCjptwM=";
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
