{ lib
, stdenv
, fetchFromGitHub
, rocmUpdateScript
, cmake
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rocm-cmake";
  version = "5.6.1";

  src = fetchFromGitHub {
    owner = "RadeonOpenCompute";
    repo = "rocm-cmake";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-vimErqzpGUXudfPV3xx+be79st/YFHqoPVmQYPUUeqA=";
  };

  nativeBuildInputs = [ cmake ];

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    owner = finalAttrs.src.owner;
    repo = finalAttrs.src.repo;
  };

  meta = with lib; {
    description = "CMake modules for common build tasks for the ROCm stack";
    homepage = "https://github.com/RadeonOpenCompute/rocm-cmake";
    license = licenses.mit;
    maintainers = teams.rocm.members;
    platforms = platforms.unix;
    broken = versions.minor finalAttrs.version != versions.minor stdenv.cc.version;
  };
})
