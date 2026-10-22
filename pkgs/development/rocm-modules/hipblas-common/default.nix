{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  rocm-cmake,
  rocmUpdateScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "hipblas-common";
  version = "10.1";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "rocm-libraries";
    tag = "therock-${finalAttrs.version}";
    sparseCheckout = [
      "projects/hipblas-common"
      "shared"
    ];
    hash = "sha256-2sUJqcy/LSfKOvY1IBzlxmbKZImMxf6YGA+qQml8DLc=";
  };
  sourceRoot = "${finalAttrs.src.name}/projects/hipblas-common";

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    rocm-cmake
  ];

  strictDeps = true;

  passthru.updateScript = rocmUpdateScript { inherit finalAttrs; };
  meta = {
    description = "Common files shared by hipBLAS and hipBLASLt";
    homepage = "https://github.com/ROCm/rocm-libraries/tree/develop/projects/hipblas-common";
    license = lib.licenses.mit;
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.linux;
  };
})
