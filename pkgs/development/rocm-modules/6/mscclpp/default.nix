{
  fetchFromGitHub,
  stdenv,
  cmake,
  clr,
  numactl,
  nlohmann_json,
}:
stdenv.mkDerivation {
  pname = "mscclpp";
  version = "unstable-2024-12-13";
  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "mscclpp";
    rev = "ee75caf365a27b9ab7521cfdda220b55429e5c37";
    hash = "sha256-/mi9T9T6OIVtJWN3YoEe9az/86rz7BrX537lqaEh3ig=";
  };
  nativeBuildInputs = [
    cmake
  ];
  buildInputs = [
    clr
    numactl
  ];
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "gfx90a gfx941 gfx942" "gfx908 gfx90a gfx942 gfx1030 gfx1100"
  '';
  cmakeFlags = [
    "-DMSCCLPP_BYPASS_GPU_CHECK=ON"
    "-DMSCCLPP_USE_ROCM=ON"
    "-DMSCCLPP_BUILD_TESTS=OFF"
    "-DGPU_TARGETS=gfx908;gfx90a;gfx942;gfx1030;gfx1100"
    "-DAMDGPU_TARGETS=gfx908;gfx90a;gfx942;gfx1030;gfx1100"
    "-DMSCCLPP_BUILD_APPS_NCCL=ON"
    "-DMSCCLPP_BUILD_PYTHON_BINDINGS=OFF"
    "-DFETCHCONTENT_QUIET=OFF"
    "-DFETCHCONTENT_TRY_FIND_PACKAGE_MODE=ALWAYS"
    "-DFETCHCONTENT_SOURCE_DIR_JSON=${nlohmann_json.src}"
  ];
  env.ROCM_PATH = clr;
}
