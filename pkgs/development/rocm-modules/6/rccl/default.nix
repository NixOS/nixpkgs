{
  lib,
  stdenv,
  fetchFromGitHub,
  rocmUpdateScript,
  cmake,
  rocm-cmake,
  rocm-smi,
  rocm-core,
  pkg-config,
  clr,
  mscclpp,
  perl,
  hipify,
  python3,
  gtest,
  chrpath,
  roctracer,
  rocprofiler,
  rocprofiler-register,
  autoPatchelfHook,
  buildTests ? false,
  gpuTargets ? (clr.localGpuTargets or [ ]),
  # for passthru.tests
  rccl,
}:

let
  useAsan = buildTests;
  useUbsan = buildTests;
  san = lib.optionalString (useAsan || useUbsan) (
    "-fno-gpu-sanitize -fsanitize=undefined "
    + (lib.optionalString useAsan "-fsanitize=address -shared-libsan ")
  );
in
# Note: we can't properly test or make use of multi-node collective ops
# https://github.com/NixOS/nixpkgs/issues/366242 tracks kernel support
# kfd_peerdirect support which is on out-of-tree amdkfd in ROCm/ROCK-Kernel-Driver
# infiniband ib_peer_mem support isn't in the mainline kernel but is carried by some distros
stdenv.mkDerivation (finalAttrs: {
  pname = "rccl${clr.gpuArchSuffix}";
  version = "6.4.3";

  outputs = [
    "out"
  ]
  ++ lib.optionals buildTests [
    "test"
  ];

  patches = [
    ./fix-mainline-support-and-ub.diff
    ./enable-mscclpp-on-all-gfx9.diff
    ./rccl-test-missing-iomanip.diff
    ./fix_hw_reg_hw_id_gt_gfx10.patch
  ];

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "rccl";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-XpD+UjgdbAoGYK5UvvTX3f8rny4tiEDH/vYoCdZhtjo=";
  };

  nativeBuildInputs = [
    cmake
    rocm-cmake
    clr
    perl
    hipify
    python3
    pkg-config
    autoPatchelfHook # ASAN doesn't add rpath without this
  ];

  buildInputs = [
    rocm-smi
    gtest
    roctracer
    rocprofiler
    rocprofiler-register
    mscclpp
  ]
  ++ lib.optionals buildTests [
    chrpath
  ];

  cmakeFlags = [
    "-DHIP_CLANG_NUM_PARALLEL_JOBS=4"
    "-DCMAKE_BUILD_TYPE=Release"
    "-DROCM_PATH=${clr}"
    "-DHIP_COMPILER=${clr}/bin/amdclang++"
    "-DCMAKE_CXX_COMPILER=${clr}/bin/amdclang++"
    "-DROCM_PATCH_VERSION=${rocm-core.ROCM_LIBPATCH_VERSION}"
    "-DROCM_VERSION=${rocm-core.ROCM_LIBPATCH_VERSION}"
    "-DBUILD_BFD=OFF" # Can't get it to detect bfd.h
    "-DENABLE_MSCCL_KERNEL=ON"
    # FIXME: this is still running a download because if(NOT mscclpp_nccl_FOUND) is commented out T_T
    "-DENABLE_MSCCLPP=OFF"
    #"-DMSCCLPP_ROOT=${mscclpp}"
    # Manually define CMAKE_INSTALL_<DIR>
    # See: https://github.com/NixOS/nixpkgs/pull/197838
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ]
  ++ lib.optionals (gpuTargets != [ ]) [
    # AMD can't make up their minds and keep changing which one is used in different projects.
    "-DAMDGPU_TARGETS=${lib.concatStringsSep ";" gpuTargets}"
    "-DGPU_TARGETS=${lib.concatStringsSep ";" gpuTargets}"
  ]
  ++ lib.optionals buildTests [
    "-DBUILD_TESTS=ON"
  ];

  # -O2 and -fno-strict-aliasing due to UB issues in RCCL :c
  # Reported upstream
  env.CFLAGS = "-I${clr}/include -I${roctracer}/include -O2 -fno-strict-aliasing ${san}-fno-omit-frame-pointer -momit-leaf-frame-pointer";
  env.CXXFLAGS = "-I${clr}/include -I${roctracer}/include -O2 -fno-strict-aliasing ${san}-fno-omit-frame-pointer -momit-leaf-frame-pointer";
  env.LDFLAGS = "${san}";
  postPatch = ''
    patchShebangs src tools
    substituteInPlace CMakeLists.txt \
      --replace-fail '${"\${HOST_OS_ID}"}' '"ubuntu"' \
      --replace-fail 'target_include_directories(rccl PRIVATE ''${ROCM_SMI_INCLUDE_DIR})' \
      'target_include_directories(rccl PRIVATE ''${ROCM_SMI_INCLUDE_DIRS})'
  '';

  postInstall =
    lib.optionalString useAsan ''
      patchelf --add-needed ${clr}/llvm/lib/linux/libclang_rt.asan-${stdenv.hostPlatform.parsed.cpu.name}.so $out/lib/librccl.so
    ''
    + lib.optionalString buildTests ''
      mkdir -p $test/bin
      mv $out/bin/* $test/bin
      rmdir $out/bin
    '';

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    inherit (finalAttrs.src) owner;
    inherit (finalAttrs.src) repo;
  };

  # This package with sanitizers + manual integration test binaries built
  # must be ran manually
  passthru.tests.rccl = rccl.override {
    buildTests = true;
  };

  meta = with lib; {
    description = "ROCm communication collectives library";
    homepage = "https://github.com/ROCm/rccl";
    license = with licenses; [
      bsd2
      bsd3
    ];
    teams = [ teams.rocm ];
    platforms = platforms.linux;
  };
})
