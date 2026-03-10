{
  lib,
  stdenv,
  fetchFromGitHub,
  rocmUpdateScript,
  rocm-core,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rocm-cmake";
  version = "7.2.0";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "rocm-cmake";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-gY6jzIIN1pSXGbCMN6y35Q/VJgbIqWDRjD8aI/fc1L0=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ rocm-core ];

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    inherit (finalAttrs.src) owner;
    inherit (finalAttrs.src) repo;
  };

  meta = {
    description = "CMake modules for common build tasks for the ROCm stack";
    homepage = "https://github.com/ROCm/rocm-cmake";
    license = lib.licenses.mit;
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.unix;
  };
})
