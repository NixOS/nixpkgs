{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  rocmUpdateScript,
  pkg-config,
  cmake,
  ninja,
  xxd,
  rocm-device-libs,
  elfutils,
  libdrm,
  numactl,
  valgrind,
  libxml2,
  rocm-merged-llvm,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rocm-runtime";
  version = "6.3.3";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "ROCR-Runtime";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-du20+5VNYgwchGO7W7FIVebBqLPtfSBnmPVbPpgEZjo=";
  };

  env.CFLAGS = "-I${numactl.dev}/include -I${elfutils.dev}/include -w";
  env.CXXFLAGS = "-I${numactl.dev}/include -I${elfutils.dev}/include -w";

  nativeBuildInputs = [
    pkg-config
    cmake
    ninja
    xxd
    rocm-merged-llvm
  ];

  buildInputs = [
    elfutils
    libdrm
    numactl
    # without valgrind, additional work for "kCodeCopyAligned11" is done in the installPhase
    valgrind
    libxml2
  ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ];

  patches = [
    # Patches for UB at runtime https://github.com/ROCm/ROCR-Runtime/issues/272
    (fetchpatch {
      # [PATCH] hsa-runtime: set underlying type of hsa_region_info_t and hsa_amd_region_info_t to int
      url = "https://github.com/ROCm/ROCR-Runtime/commit/39a6a168fa07e289a10f6e20e6ead4e303e99ba0.patch";
      hash = "sha256-CshJJDvII1nNyNmt+YjwMwfBHUTlrdsxkhwfgBwO+WE=";
    })
    (fetchpatch {
      # [PATCH] rocr: refactor of runtime.cpp based on Coverity
      url = "https://github.com/ROCm/ROCR-Runtime/commit/441bd9fe6c7bdb5c4c31f71524ed642786bc923e.patch";
      hash = "sha256-7bQXxGkipzgT2aXRxCuh3Sfmo/zc/IOmA0x1zB+fMb0=";
    })
    (fetchpatch {
      # [PATCH] queues: fix UB due to 1 << 31
      url = "https://github.com/ROCm/ROCR-Runtime/commit/9b8a0f5dbee1903fa990a7d8accc1c5fbc549636.patch";
      hash = "sha256-KlZWjfngH8yKly08iwC+Bzpvp/4dkaTpRIKdFYwRI+U=";
    })
    (fetchpatch {
      # [PATCH] topology: fix UB due to 1 << 31
      url = "https://github.com/ROCm/ROCR-Runtime/commit/d1d00bfee386d263e13c2b64fb6ffd1156deda7c.patch";
      hash = "sha256-u70WEZaphQ7qTfgQPFATwdKWtHytu7CFH7Pzv1rOM8w=";
    })
    (fetchpatch {
      # [PATCH] kfd_ioctl: fix UB due to 1 << 31
      url = "https://github.com/ROCm/ROCR-Runtime/commit/41bfc66aef437a5b349f71105fa4b907cc7e17d5.patch";
      hash = "sha256-A7VhPR3eSsmjq2cTBSjBIz9i//WiNjoXm0EsRKtF+ns=";
    })
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

    export HIP_DEVICE_LIB_PATH="${rocm-device-libs}/amdgcn/bitcode"
  '';

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    inherit (finalAttrs.src) owner;
    inherit (finalAttrs.src) repo;
  };

  meta = with lib; {
    description = "Platform runtime for ROCm";
    homepage = "https://github.com/ROCm/ROCR-Runtime";
    license = with licenses; [ ncsa ];
    maintainers = with maintainers; [ lovesegfault ];
    teams = [ teams.rocm ];
    platforms = platforms.linux;
  };
})
