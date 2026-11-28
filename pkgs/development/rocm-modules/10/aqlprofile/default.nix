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
  version = "10.1";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "rocm-systems";
    tag = "therock-${finalAttrs.version}";
    sparseCheckout = [
      "projects/aqlprofile"
      "shared"
    ];
    hash = "sha256-7yeEJoyShSCwy1MTCeArYBabh5qTVm5uZL8N74rvxPA=";
  };
  sourceRoot = "${finalAttrs.src.name}/projects/aqlprofile";

  __structuredAttrs = true;
  strictDeps = true;

  env.CXXFLAGS = "-DROCP_LD_AQLPROFILE=1";

  nativeBuildInputs = [
    cmake
    clr
  ];

  buildInputs = [
    clr
  ];

  passthru.updateScript = rocmUpdateScript { inherit finalAttrs; };

  meta = {
    description = "AQLPROFILE library for AMD HSA runtime API extension support";
    homepage = "https://github.com/ROCm/rocm-systems/tree/develop/projects/aqlprofile";
    changelog = "https://github.com/ROCm/rocm-systems/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.linux;
  };
})
