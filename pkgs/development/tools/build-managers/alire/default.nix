{ lib
, stdenv
, fetchFromGitHub
, gprbuild
, gnat
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "alire";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "alire-project";
    repo = "alire";
    rev = "v${finalAttrs.version}";
    hash = "sha256-fJXt3mM/v87hWumML6L3MH1O/uKkzmpE58B9nDRohzM=";

    fetchSubmodules = true;
  };

  nativeBuildInputs = [ gprbuild gnat ];

  postPatch = ''
    patchShebangs ./dev/build.sh
  '';

  buildPhase = ''
    runHook preBuild

    export ALIRE_BUILD_JOBS="$NIX_BUILD_CORES"
    ./dev/build.sh

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r ./bin $out

    runHook postInstall
  '';

  meta = {
    description = "A source-based package manager for the Ada and SPARK programming languages";
    homepage = "https://alire.ada.dev";
    changelog = "https://github.com/alire-project/alire/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ atalii ];
    platforms = lib.platforms.unix;
    mainProgram = "alr";
  };
})
