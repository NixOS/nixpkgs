{
  stdenv,
  cmake,
  fetchFromGitHub,
  rocm-cmake,
  rocmUpdateScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "hipblas-common";
  version = "6.3.1";
  nativeBuildInputs = [
    cmake
    rocm-cmake
  ];

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    inherit (finalAttrs.src) owner;
    inherit (finalAttrs.src) repo;
  };
  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "hipBLAS-common";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-tvNz4ymQ1y3YSUQxAtNu2who79QzSKR+3JEevr+GDWo=";
  };
})
