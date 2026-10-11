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
  version = "10.1.0";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "rocm-systems";
    tag = "therock-${lib.versions.majorMinor finalAttrs.version}";
    sparseCheckout = [
      "projects/aqlprofile"
      "shared"
    ];
    hash = "sha256-7yeEJoyShSCwy1MTCeArYBabh5qTVm5uZL8N74rvxPA=";
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
    license = lib.licenses.mit;
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.linux;
  };
})
