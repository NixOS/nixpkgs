{
  lib,
  stdenv,
  fetchFromGitHub,
  rocmPackages,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rocm-bandwidth-test";
  version = "6.3.3";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "rocm_bandwidth_test";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-dHyfYpRB13wUvim152nZ61McZOQ1zUZFx4dUo2vVqZM=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [ rocmPackages.rocm-runtime ];

  cmakeFlags = [
    "-DROCT_INC_DIR=${rocmPackages.rocm-runtime}/include/libhsakmt"
  ];

  meta = with lib; {
    description = "Bandwidth test for AMD GPUs supported by ROCm";
    homepage = "https://github.com/ROCm/rocm_bandwidth_test";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fangpen ];
    teams = [ teams.rocm ];
    platforms = [ "x86_64-linux" ];
  };
})
