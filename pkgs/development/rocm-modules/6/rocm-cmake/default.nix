{ lib
, stdenv
, fetchFromGitHub
, rocmUpdateScript
, cmake
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rocm-cmake";
  version = "6.2.2";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "rocm-cmake";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-xX0dEK+IitEBe0MuB3LHFZFRrQVmSI3+wq9k8l47tRU=";
  };

  nativeBuildInputs = [ cmake ];

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    owner = finalAttrs.src.owner;
    repo = finalAttrs.src.repo;
  };

  meta = with lib; {
    description = "CMake modules for common build tasks for the ROCm stack";
    homepage = "https://github.com/ROCm/rocm-cmake";
    license = licenses.mit;
    maintainers = teams.rocm.members;
    platforms = platforms.unix;
    broken = versions.minor finalAttrs.version != versions.minor stdenv.cc.version || versionAtLeast finalAttrs.version "7.0.0";
  };
})
