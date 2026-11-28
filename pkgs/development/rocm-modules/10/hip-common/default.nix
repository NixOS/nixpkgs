{
  lib,
  stdenv,
  fetchFromGitHub,
  rocmUpdateScript,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hip-common";
  version = "10.1";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "rocm-systems";
    tag = "therock-${finalAttrs.version}";
    sparseCheckout = [
      "projects/hip"
      "shared"
    ];
    hash = "sha256-MP92iAemtjBLt9hy4JJpud+UfT2xolfm7mtLknrU5EE=";
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
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lovesegfault ];
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.linux;
  };
})
