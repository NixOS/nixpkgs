{
  lib,
  stdenv,
  rocmSystemsSrc,
  rocmSystemsVersion,
}:

stdenv.mkDerivation {
  pname = "hip-common";
  version = rocmSystemsVersion;

  src = rocmSystemsSrc;
  sourceRoot = "${rocmSystemsSrc.name}/projects/hip";

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    mv * $out

    runHook postInstall
  '';

  meta = {
    description = "C++ Heterogeneous-Compute Interface for Portability";
    homepage = "https://github.com/ROCm/rocm-systems/tree/develop/projects/hip";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ lovesegfault ];
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.linux;
  };
}
