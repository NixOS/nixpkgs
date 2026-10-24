{
  lib,
  fetchFromGitHub,
  stdenv,
  cmake,
  clr,
  numactl,
  nlohmann_json,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "mscclpp";
  version = "0.5.2-unstable-2024-12-13";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "mscclpp";
    rev = "ee75caf365a27b9ab7521cfdda220b55429e5c37";
    hash = "sha256-/mi9T9T6OIVtJWN3YoEe9az/86rz7BrX537lqaEh3ig=";
  };

  __structuredAttrs = true;
  strictDeps = true;

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
    (lib.cmakeBool "MSCCLPP_BYPASS_GPU_CHECK" true)
    (lib.cmakeBool "MSCCLPP_USE_ROCM" true)
    (lib.cmakeBool "MSCCLPP_BUILD_TESTS" false)
    (lib.cmakeFeature "GPU_TARGETS" "gfx908;gfx90a;gfx942;gfx1030;gfx1100")
    (lib.cmakeFeature "AMDGPU_TARGETS" "gfx908;gfx90a;gfx942;gfx1030;gfx1100")
    (lib.cmakeBool "MSCCLPP_BUILD_APPS_NCCL" true)
    (lib.cmakeBool "MSCCLPP_BUILD_PYTHON_BINDINGS" false)
    (lib.cmakeBool "FETCHCONTENT_QUIET" false)
    (lib.cmakeFeature "FETCHCONTENT_TRY_FIND_PACKAGE_MODE" "ALWAYS")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_JSON" "${nlohmann_json.src}")
  ];

  env.ROCM_PATH = clr;

  meta = {
    description = "GPU-driven communication stack for scalable AI applications";
    homepage = "https://github.com/microsoft/mscclpp";
    license = lib.licenses.mit;
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.linux;
  };
})
