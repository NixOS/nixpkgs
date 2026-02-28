{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  rocmUpdateScript,
  pkg-config,
  cmake,
  xxd,
  rocm-device-libs,
  elfutils,
  libdrm,
  numactl,
  llvm,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rocm-runtime";
  version = "7.2.0";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "ROCR-Runtime";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-6xELKQ/uqAoorsCR/H7d8iNK7LsVNsW2DRRZo5cU7UM=";
  };

  cmakeBuildType = "RelWithDebInfo";
  separateDebugInfo = true;
  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    cmake
    xxd # used by create_hsaco_ascii_file.sh
    llvm.rocm-toolchain
  ];

  buildInputs = [
    llvm.clang-unwrapped
    llvm.llvm
    elfutils
    libdrm
    numactl
  ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ];

  patches = [
    # Vendored upstream PR for fix for segfault when queue allocation fails
    # https://github.com/ROCm/rocm-systems/pull/2850
    ./queue-failure.patch
    (fetchpatch {
      # [PATCH] rocr: Extend HIP ISA compatibility check
      sha256 = "sha256-8r2Lb5lBfFaZC3knCxfXGcnkzNv6JxOKyJn2rD5gus4=";
      url = "https://github.com/GZGavinZhao/rocm-systems/commit/dcef23cf896f4dcbc7ed81abeaa4ec2208dcdd8c.patch";
      relative = "projects/rocr-runtime";
    })
    (fetchpatch {
      # [PATCH] kfd_ioctl: fix UB due to 1 << 31
      url = "https://github.com/ROCm/ROCR-Runtime/commit/41bfc66aef437a5b349f71105fa4b907cc7e17d5.patch";
      hash = "sha256-A7VhPR3eSsmjq2cTBSjBIz9i//WiNjoXm0EsRKtF+ns=";
    })
    (fetchpatch {
      # [PATCH] hsakmt: Expose and use CWSR and Control stack sizes (#2200)
      # Fixes potential mismatches between stack sizes configured in amdgpu kernel module
      # and userspace by relying on kernel value when available
      # Falls back to hardcoded size based on ISA if kernel is too old. For gfx1151, also prints:
      # WARNING: KFD ABI 1.20+ is recommended … This may result in faults, crashes and other application instability
      # This allows new kernels to work with this runtime detection mechanism
      # Only gfx1151 warns loudly because only it has had the size updated in kernel…
      name = "rocr-runtime-kernel-stack-size.patch";
      url = "https://github.com/ROCm/rocm-systems/commit/7037a71f311c021974fafd13727dfefd8a1cc79d.patch";
      relative = "projects/rocr-runtime";
      hash = "sha256-EbDxuEvNu0fyQJZmqq0fbcCdNtaEWUbmyPLvcfqDPjc=";
    })
    # This causes a circular dependency, aqlprofile relies on hsa-runtime64
    # which is part of rocm-runtime
    # Worked around by having rocprofiler load aqlprofile directly
    ./remove-hsa-aqlprofile-dep.patch
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

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    inherit (finalAttrs.src) owner;
    inherit (finalAttrs.src) repo;
  };

  meta = {
    description = "Platform runtime for ROCm";
    homepage = "https://github.com/ROCm/ROCR-Runtime";
    license = with lib.licenses; [ ncsa ];
    maintainers = with lib.maintainers; [ lovesegfault ];
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.linux;
  };
})
