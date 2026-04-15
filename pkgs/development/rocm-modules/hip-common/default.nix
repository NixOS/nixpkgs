{
  lib,
  stdenv,
  fetchFromGitHub,
  rocmUpdateScript,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hip-common";
  version = "7.2.1";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "rocm-systems";
    rev = "rocm-${finalAttrs.version}";
    sparseCheckout = [
      "projects/hip"
      "shared"
    ];
    hash = "sha256-orfTXKjcZJ5E73cmXEyltZVYhCQo8FLExVHM3J/rqUM=";
  };
  sourceRoot = "${finalAttrs.src.name}/projects/hip";

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
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ lovesegfault ];
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.linux;
  };
})
