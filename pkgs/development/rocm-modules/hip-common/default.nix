{
  lib,
  stdenv,
  fetchFromGitHub,
  rocmUpdateScript,
  bashNonInteractive,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hip-common";
  version = "7.2.3";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "rocm-systems";
    tag = "rocm-${finalAttrs.version}";
    sparseCheckout = [
      "projects/hip"
      "shared"
    ];
    hash = "sha256-orfTXKjcZJ5E73cmXEyltZVYhCQo8FLExVHM3J/rqUM=";
  };
  sourceRoot = "${finalAttrs.src.name}/projects/hip";

  __structuredAttrs = true;
  strictDeps = true;

  buildInputs = [ bashNonInteractive ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    mv * $out

    runHook postInstall
  '';

  passthru.updateScript = rocmUpdateScript { inherit finalAttrs; };

  meta = {
    description = "C++ Heterogeneous-Compute Interface for Portability";
    homepage = "https://github.com/ROCm/rocm-systems/tree/develop/projects/hip";
    changelog = "https://github.com/ROCm/rocm-systems/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lovesegfault ];
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.linux;
  };
})
