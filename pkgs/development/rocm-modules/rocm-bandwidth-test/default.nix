{
  lib,
  stdenv,
  fetchFromGitHub,
  rocmUpdateScript,
  rocmPackages,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rocm-bandwidth-test";
  version = "6.3.3";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "rocm_bandwidth_test";
    tag = "rocm-${finalAttrs.version}";
    hash = "sha256-dHyfYpRB13wUvim152nZ61McZOQ1zUZFx4dUo2vVqZM=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [ rocmPackages.rocm-runtime ];

  cmakeFlags = [
    (lib.cmakeFeature "ROCT_INC_DIR" "${rocmPackages.rocm-runtime}/include/libhsakmt")
  ];

  passthru.updateScript = rocmUpdateScript { inherit finalAttrs; };

  meta = {
    description = "Bandwidth test for AMD GPUs supported by ROCm";
    homepage = "https://github.com/ROCm/rocm_bandwidth_test";
    changelog = "https://github.com/ROCm/rocm_bandwidth_test/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    mainProgram = "rocm-bandwidth-test";
    maintainers = with lib.maintainers; [ fangpen ];
    teams = [ lib.teams.rocm ];
    platforms = [ "x86_64-linux" ];
  };
})
