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
  version = "7.2.3";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "half";
    tag = "rocm-${finalAttrs.version}";
    hash = "sha256-If9O5BEeymsLN+C0drZsPSxEWXpJTxeDBGNHNXSumm4=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    cmake
    rocm-cmake
  ];

  buildInputs = [
    rocm-cmake
  ];

  passthru.updateScript = rocmUpdateScript { inherit finalAttrs; };

  meta = {
    description = "C++ library for half precision floating point arithmetics";
    homepage = "https://github.com/ROCm/half";
    changelog = "https://github.com/ROCm/half/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.unix;
  };
})
