{ lib
, stdenv
, fetchFromGitHub
, rocmUpdateScript
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hip-common";
  version = "6.0.2";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "HIP";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-51u3By0R4LKoWiklNacFP6HILL845jxpN6FD7rQB+zQ=";
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
    owner = finalAttrs.src.owner;
    repo = finalAttrs.src.repo;
  };

  meta = {
    description = "C++ Heterogeneous-Compute Interface for Portability";
    homepage = "https://github.com/ROCm/HIP";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ lovesegfault ] ++ lib.teams.rocm.members;
    platforms = lib.platforms.linux;
    broken = lib.versions.minor finalAttrs.version != lib.versions.minor stdenv.cc.version || lib.versionAtLeast finalAttrs.version "7.0.0";
  };
})
