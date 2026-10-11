{
  lib,
  stdenv,
  fetchFromGitHub,
  rocmUpdateScript,
  testers,
  rocm-core,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rocm-cmake";
  version = "7.2.3";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "rocm-cmake";
    tag = "rocm-${finalAttrs.version}";
    hash = "sha256-gY6jzIIN1pSXGbCMN6y35Q/VJgbIqWDRjD8aI/fc1L0=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [ cmake ];

  buildInputs = [ rocm-core ];

  passthru = {
    updateScript = rocmUpdateScript { inherit finalAttrs; };
    tests.cmake-config = testers.hasCmakeConfigModules { package = finalAttrs.finalPackage; };
  };

  meta = {
    description = "CMake modules for common build tasks for the ROCm stack";
    homepage = "https://github.com/ROCm/rocm-cmake";
    changelog = "https://github.com/ROCm/rocm-cmake/releases/tag/${finalAttrs.src.tag}";
    cmakeConfigModules = [
      "ROCM"
      "ROCmCMakeBuildTools"
    ];
    license = lib.licenses.mit;
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.unix;
  };
})
