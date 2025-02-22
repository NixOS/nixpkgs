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
  rocm-llvm,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rocm-runtime";
  version = "6.3.1";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "ROCR-Runtime";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-btpiIPV9REMvrmRSUzBIpBO6ehVIMmEmG+H8hqHDxdE=";
  };

  env.CFLAGS = "-I${numactl.dev}/include -I${elfutils.dev}/include -w";
  env.CXXFLAGS = "-I${numactl.dev}/include -I${elfutils.dev}/include -w";

  nativeBuildInputs = [
    pkg-config
    cmake
    ninja
    xxd
    rocm-llvm
  ];

  buildInputs = [
    elfutils
    libdrm
    numactl
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
    patchShebangs --host image
    patchShebangs --host core
    patchShebangs --host runtime

    substituteInPlace CMakeLists.txt \
      --replace 'hsa/include/hsa' 'include/hsa'

    # We compile clang before rocm-device-libs, so patch it in afterwards
    # Replace object version: https://github.com/ROCm/ROCR-Runtime/issues/166 (TODO: Remove on LLVM update?)
    # substituteInPlace image/blit_src/CMakeLists.txt \
    #   --replace '-cl-denorms-are-zero' '-cl-denorms-are-zero --rocm-device-lib-path=${rocm-device-libs}/amdgcn/bitcode' \
    #   --replace '-mcode-object-version=4' '-mcode-object-version=5'

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
    maintainers = with maintainers; [ lovesegfault ] ++ teams.rocm.members;
    platforms = platforms.linux;
  };
})
