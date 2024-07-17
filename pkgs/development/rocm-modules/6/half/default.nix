{
  lib,
  stdenv,
  fetchFromGitHub,
  rocmUpdateScript,
  cmake,
  rocm-cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "half";
  version = "6.0.2";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "half";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-wvl8ny7pbY9hUGGtJ70R7/4YIsahgI7qcVzUnxmUfZM=";
  };

  nativeBuildInputs = [
    cmake
    rocm-cmake
  ];

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    owner = finalAttrs.src.owner;
    repo = finalAttrs.src.repo;
  };

  meta = with lib; {
    description = "C++ library for half precision floating point arithmetics";
    homepage = "https://github.com/ROCm/half";
    license = with licenses; [ mit ];
    maintainers = teams.rocm.members;
    platforms = platforms.unix;
    broken =
      versions.minor finalAttrs.version != versions.minor stdenv.cc.version
      || versionAtLeast finalAttrs.version "7.0.0";
  };
})
