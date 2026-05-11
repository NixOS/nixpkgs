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
  version = "7.2.2";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "rocm-libraries";
    rev = "rocm-${finalAttrs.version}";
    sparseCheckout = [
      "projects/hipblas-common"
      "shared"
    ];
    hash = "sha256-83LgS4I1fMSaNtWdVFf1qhYRMT7a9jVzO3XpUzEipXg=";
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
    license = with lib.licenses; [ mit ];
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.linux;
  };
})
