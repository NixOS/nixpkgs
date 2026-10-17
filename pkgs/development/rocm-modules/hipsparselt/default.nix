{
  lib,
  stdenv,
  fetchFromGitHub,
  rocmUpdateScript,
  cmake,
  ninja,
  git,
  pkg-config,
  rocm-cmake,
  rocm-smi,
  clr,
  hipsparse,
  openmp,
  llvm,
  msgpack-cxx,
  libxml2,
  zlib,
  zstd,
  python3,
  python3Packages,
  # hipsparselt only supports gfx942/gfx950
  gpuTargets ? (clr.localGpuTargets or clr.gpuTargets),
}:

let
  supportedTargets = (
    lib.lists.intersectLists gpuTargets [
      "gfx942"
      "gfx950"
    ]
  );
  supportsTargetArches = supportedTargets != [ ];
  py = python3.withPackages (ps: [
    ps.pyyaml
    ps.setuptools
    ps.packaging
    ps.nanobind
    ps.msgpack
    ps.joblib
  ]);
  compiler = "amdclang++";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "hipsparselt${clr.gpuArchSuffix}";
  version = "10.1";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "rocm-libraries";
    tag = "therock-${finalAttrs.version}";
    hash = "sha256-pJvsJv007YCXR4YiOq3qFWlcDFoGxwKovNSk0Mjxnes=";
    sparseCheckout = [
      "projects/hipsparselt"
      "projects/hipblaslt/tensilelite"
      "projects/hipblaslt/cmake"
      "projects/hipblaslt/device-library"
      # hipsparselt configures hipBLASLt's CMakeLists (for rocisa), whose
      # configure_file needs library/include/hipblaslt-version.h.in
      # (248K of headers only — not the ~476M library yaml tree).
      "projects/hipblaslt/library/include"
      "shared/origami"
      # rocisa (tensilelite/rocisa/CMakeLists.txt) add_subdirectory's stinkytofu
      "shared/stinkytofu"
    ];
  };
  sourceRoot = "${finalAttrs.src.name}/projects/hipsparselt";

  # stinkytofu (pulled in as a rocisa sibling) unconditionally include(ClangTidy)s
  # from the monorepo top-level cmake/ dir, which our sparseCheckout omits (lint
  # target we never build). Drop it (same ClangTidy fix as hipBLASLt).
  postPatch = ''
    substituteInPlace ../../shared/stinkytofu/CMakeLists.txt \
      --replace-fail 'include(ClangTidy)' "" \
      --replace-fail 'add_clang_tidy_custom_target()' ""
  '';

  env.CXX = compiler;
  env.ROCM_PATH = "${clr}";
  env.TENSILE_ROCM_ASSEMBLER_PATH = lib.getExe' clr "amdclang++";
  env.TENSILE_GEN_ASSEMBLY_TOOLCHAIN = lib.getExe' clr "amdclang++";
  # tensilelite's HelperKernelCache defaults its cache dir to
  # $HOME/.tensile/helper_cache; the Nix sandbox $HOME (/homeless-shelter) is
  # unwritable, so store() -> mkdir raises PermissionError right after codegen
  # (same failure as hipBLASLt). Disable the Nix-useless cross-invocation cache
  # and point HOME at $TMPDIR belt-and-suspenders.
  env.TENSILE_DISABLE_HELPER_CACHE = "1";
  preBuild = ''
    export HOME=$TMPDIR
  '';

  requiredSystemFeatures = [ "big-parallel" ];

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    cmake
    ninja
    git
    pkg-config
    rocm-cmake
    rocm-smi
    py
    clr
  ];

  buildInputs = [
    llvm.llvm
    clr
    rocm-cmake
    hipsparse
    openmp
    msgpack-cxx
    libxml2
    python3Packages.msgpack
    zlib
    zstd
  ];

  cmakeFlags = [
    (lib.cmakeFeature "GPU_TARGETS" (lib.concatStringsSep ";" supportedTargets))
    (lib.cmakeBool "HIPSPARSELT_ENABLE_DEVICE" supportsTargetArches)
    (lib.cmakeBool "HIPSPARSELT_ENABLE_CLIENT" false)
    (lib.cmakeBool "HIPSPARSELT_BUILD_TESTING" false)
    (lib.cmakeBool "HIPSPARSELT_ENABLE_MARKER" false)
    (lib.cmakeBool "HIPBLASLT_ENABLE_ROCROLLER" false)
    (lib.cmakeBool "HIPBLASLT_ENABLE_MARKER" false)
    (lib.cmakeFeature "CMAKE_C_COMPILER" "amdclang")
    (lib.cmakeFeature "CMAKE_HIP_COMPILER" compiler)
    (lib.cmakeFeature "CMAKE_CXX_COMPILER" compiler)
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_NANOBIND" "${python3Packages.nanobind.src}")
    (lib.cmakeFeature "CMAKE_INSTALL_BINDIR" "bin")
    (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib")
    (lib.cmakeFeature "CMAKE_INSTALL_INCLUDEDIR" "include")
  ];

  passthru.supportsTargetArches = supportsTargetArches;
  passthru.updateScript = rocmUpdateScript { inherit finalAttrs; };

  meta = {
    description = "ROCm hipSPARSELt - a SPARSE marshalling library";
    homepage = "https://github.com/ROCm/rocm-libraries/tree/develop/projects/hipsparselt";
    license = lib.licenses.mit;
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.linux;
  };
})
