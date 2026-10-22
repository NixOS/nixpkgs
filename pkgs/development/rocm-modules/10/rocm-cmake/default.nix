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
  version = "10.1";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "rocm-cmake";
    tag = "therock-${finalAttrs.version}";
    hash = "sha256-im6UO0crO0Jc27zkTsdvJYPHit8IGlw/vDPGrmP1XqY=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ rocm-core ];

  passthru.updateScript = rocmUpdateScript { inherit finalAttrs; };

  meta = {
    description = "CMake modules for common build tasks for the ROCm stack";
    homepage = "https://github.com/ROCm/rocm-cmake";
    license = lib.licenses.mit;
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.unix;
  };
})
