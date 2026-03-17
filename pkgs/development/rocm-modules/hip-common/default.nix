{
  lib,
  stdenv,
  fetchRocmMonorepoSource,
  rocmVersion,
}:

let
  source = rec {
    repo = "rocm-systems";
    version = rocmVersion;
    sourceSubdir = "projects/hip";
    hash = "sha256-SpGJi4Qc7rDwNJgtjHU48wrRpVW7odbLXydLlrMnZ1U=";
    src = fetchRocmMonorepoSource {
      inherit
        hash
        repo
        sourceSubdir
        version
        ;
    };
    sourceRoot = "${src.name}/${sourceSubdir}";
    homepage = "https://github.com/ROCm/${repo}/tree/rocm-${version}/${sourceSubdir}";
  };
in
stdenv.mkDerivation {
  pname = "hip-common";
  inherit (source) version src sourceRoot;

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    mv * $out

    runHook postInstall
  '';

  meta = {
    inherit (source) homepage;
    description = "C++ Heterogeneous-Compute Interface for Portability";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ lovesegfault ];
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.linux;
  };
}
