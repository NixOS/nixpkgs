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
  version = "6.3.1";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "rocm-cmake";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-8kEcwqHJF584AteuddP7Ai7n6ltVZJ8a6RsYIWGMs0U=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ rocm-core ];

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    inherit (finalAttrs.src) owner;
    inherit (finalAttrs.src) repo;
  };

  meta = with lib; {
    description = "CMake modules for common build tasks for the ROCm stack";
    homepage = "https://github.com/ROCm/rocm-cmake";
    license = licenses.mit;
    maintainers = teams.rocm.members;
    platforms = platforms.unix;
  };
})
