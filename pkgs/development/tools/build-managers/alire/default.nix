{ lib
, stdenv
, fetchFromGitHub
, gprbuild
, gnat
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "alire";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "alire-project";
    repo = "alire";
    rev = "v${finalAttrs.version}";
    hash = "sha256-rwNiSXOIIQR1I8wwp1ROVOfEChT6SCa5c6XnTRqekDc=";

    fetchSubmodules = true;
  };

  nativeBuildInputs = [ gprbuild gnat ];

  # on HEAD (roughly 2c4e5a3), alire provides a dev/build.sh script. for now,
  # just use gprbuild.
  buildPhase = ''
    runHook preBuild

    gprbuild -j$NIX_BUILD_CORES -P alr_env

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
