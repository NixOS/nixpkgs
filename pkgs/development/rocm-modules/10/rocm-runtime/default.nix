{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  rocmUpdateScript,
  pkg-config,
  cmake,
  python3,
  xxd,
  rocm-device-libs,
  rocprofiler-register,
  elfutils,
  libdrm,
  numactl,
  llvm,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rocm-runtime";
  version = "10.1";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "rocm-systems";
    tag = "therock-${finalAttrs.version}";
    sparseCheckout = [
      "projects/rocr-runtime"
      "shared"
    ];
    hash = "sha256-fY6/ofaZe94ZK7An6bSHcLj0T92OCQCflnBk5onVzzo=";
  };
  sourceRoot = "${finalAttrs.src.name}/projects/rocr-runtime";

  cmakeBuildType = "RelWithDebInfo";
  separateDebugInfo = true;
  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    cmake
    python3 # trap_handler/CMakeLists.txt: find_package(Python3 Interpreter)
    xxd # used by create_hsaco_ascii_file.sh
    llvm.rocm-toolchain
  ];

  buildInputs = [
    llvm.clang-unwrapped
    llvm.llvm
    elfutils
    libdrm
    numactl
    rocprofiler-register
  ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ];

  patches = [
    (fetchpatch {
      # [PATCH] rocr: Extend HIP ISA compatibility check
      hash = "sha256-8r2Lb5lBfFaZC3knCxfXGcnkzNv6JxOKyJn2rD5gus4=";
      url = "https://github.com/GZGavinZhao/rocm-systems/commit/dcef23cf896f4dcbc7ed81abeaa4ec2208dcdd8c.patch";
      relative = "projects/rocr-runtime";
    })
  ];

  postPatch = ''
    patchShebangs --build \
      runtime/hsa-runtime/core/runtime/trap_handler/create_trap_handler_header.sh \
      runtime/hsa-runtime/core/runtime/blit_shaders/create_blit_shader_header.sh \
      runtime/hsa-runtime/image/blit_src/create_hsaco_ascii_file.sh
    patchShebangs --host image core runtime

    substituteInPlace CMakeLists.txt \
      --replace 'hsa/include/hsa' 'include/hsa'

    substituteInPlace runtime/hsa-runtime/image/blit_src/CMakeLists.txt \
      --replace-fail 'COMMAND clang' "COMMAND ${llvm.rocm-toolchain}/bin/clang"

    export HIP_DEVICE_LIB_PATH="${rocm-device-libs}/amdgcn/bitcode"
  '';

  passthru.updateScript = rocmUpdateScript { inherit finalAttrs; };

  meta = {
    description = "Platform runtime for ROCm";
    homepage = "https://github.com/ROCm/rocm-systems/tree/develop/projects/rocr-runtime";
    license = lib.licenses.ncsa;
    maintainers = with lib.maintainers; [ lovesegfault ];
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.linux;
  };
})
