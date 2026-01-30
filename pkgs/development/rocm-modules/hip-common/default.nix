{
  lib,
  stdenv,
  fetchFromGitHub,
  rocmUpdateScript,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hip-common";
  version = "7.1.1";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "HIP";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-aI41HdyzyE5HtCbzFmTQYGMiFyQELM/MTVOAbQsg8So=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    mv * $out

    runHook postInstall
  '';

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    inherit (finalAttrs.src) owner;
    inherit (finalAttrs.src) repo;
  };

  meta = {
    description = "C++ Heterogeneous-Compute Interface for Portability";
    homepage = "https://github.com/ROCm/HIP";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ lovesegfault ];
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.linux;
  };
})
