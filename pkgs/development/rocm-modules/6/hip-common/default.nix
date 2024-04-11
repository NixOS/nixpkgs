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

  meta = with lib; {
    description = "C++ Heterogeneous-Compute Interface for Portability";
    homepage = "https://github.com/ROCm/HIP";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ lovesegfault ] ++ teams.rocm.members;
    platforms = platforms.linux;
    broken = versions.minor finalAttrs.version != versions.minor stdenv.cc.version || versionAtLeast finalAttrs.version "7.0.0";
  };
})
