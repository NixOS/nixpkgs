{
  lib,
  stdenv,
  clr,
  cmake,
  fetchFromGitHub,
  rocmUpdateScript,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "aqlprofile";
  version = "7.2.2";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "rocm-systems";
    rev = "rocm-${finalAttrs.version}";
    sparseCheckout = [
      "projects/aqlprofile"
      "shared"
    ];
    hash = "sha256-74HjB5Ughu17rSRx9mfCCsPJI4TVyXnT4aU7vIbm7ak=";
  };
  sourceRoot = "${finalAttrs.src.name}/projects/aqlprofile";

  env.CXXFLAGS = "-DROCP_LD_AQLPROFILE=1";

  nativeBuildInputs = [
    cmake
    clr
  ];

  passthru.updateScript = rocmUpdateScript { inherit finalAttrs; };

  meta = {
    description = "AQLPROFILE library for AMD HSA runtime API extension support";
    homepage = "https://github.com/ROCm/rocm-systems/tree/develop/projects/aqlprofile";
    license = with lib.licenses; [ mit ];
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.linux;
  };
})
