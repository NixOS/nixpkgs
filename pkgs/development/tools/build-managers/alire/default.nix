{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, gprbuild
, gnat
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "alire";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "alire-project";
    repo = "alire";
    rev = "v${finalAttrs.version}";
    hash = "sha256-WF7spXwQR04zIGWazUrbCdeLYOzsk8C6G+cfSS6bwdE=";

    fetchSubmodules = true;
  };

  nativeBuildInputs = [ gprbuild gnat ];

  patches = [(fetchpatch {
    name = "control-build-jobs.patch";
    url = "https://github.com/alire-project/alire/pull/1651.patch";
    hash = "sha256-CBQm8Doydze/KouLWuYm+WYlvnDguR/OuX8A4y4F6fo=";
  })];

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
