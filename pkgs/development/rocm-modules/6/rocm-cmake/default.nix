{ lib
, stdenv
, fetchFromGitHub
, rocmUpdateScript
, cmake
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rocm-cmake";
  version = "6.0.2";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "rocm-cmake";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-qSjWT0KOQ5oDV06tfnKN+H/JzdoOnR9KY0c+SjvDepM=";
  };

  nativeBuildInputs = [ cmake ];

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    owner = finalAttrs.src.owner;
    repo = finalAttrs.src.repo;
  };

  meta = {
    description = "CMake modules for common build tasks for the ROCm stack";
    homepage = "https://github.com/ROCm/rocm-cmake";
    license = lib.licenses.mit;
    maintainers = lib.teams.rocm.members;
    platforms = lib.platforms.unix;
    broken = lib.versions.minor finalAttrs.version != lib.versions.minor stdenv.cc.version || lib.versionAtLeast finalAttrs.version "7.0.0";
  };
})
