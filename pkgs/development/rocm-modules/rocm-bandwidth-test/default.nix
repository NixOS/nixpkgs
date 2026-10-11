{
  lib,
  stdenv,
  fetchFromGitHub,
  rocmPackages,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rocm-bandwidth-test";
  # Kept at 6.3.3: rocm_bandwidth_test has no ROCm 10.x tag (newest upstream is
  # rocm-7.2.4). Standalone diagnostic utility; updating it is a separate change.
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
