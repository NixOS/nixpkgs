{
  lib,
  stdenv,
  fetchFromGitHub,
  rocmUpdateScript,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hip-common";
  version = "6.3.3";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "HIP";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-eKDbuG57KCg/nZpy+RcDsjyw0pP68qO9K/3ZpSPuMNw=";
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

  meta = with lib; {
    description = "C++ Heterogeneous-Compute Interface for Portability";
    homepage = "https://github.com/ROCm/HIP";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ lovesegfault ];
    teams = [ teams.rocm ];
    platforms = platforms.linux;
  };
})
