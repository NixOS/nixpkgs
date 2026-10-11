{
  lib,
  stdenv,
  fetchFromGitHub,
  rocmUpdateScript,
  cmake,
  rocm-cmake,
  amdsmi,
  rocm-core,
  pkg-config,
  clr,
  perl,
  hipify,
  python3,
  fmt,
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
  version = "10.1.0";

  outputs = [
    "out"
  ]
  ++ lib.optionals buildTests [
    "test"
  ];

  patches = [
    ./rccl-test-missing-iomanip.diff
  ];

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "rocm-systems";
    tag = "therock-${lib.versions.majorMinor finalAttrs.version}";
    sparseCheckout = [
      "projects/rccl"
      "shared"
    ];
    hash = "sha256-OkX15/P1wQ9E8QfAOklXvxmVw700kvIyi6CwdorqNhA=";
  };
  sourceRoot = "${finalAttrs.src.name}/projects/rccl";

  requiredSystemFeatures = [ "big-parallel" ]; # Very resource intensive LTO

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
    # CMakeLists.txt: find_package(amd_smi), gated on ROCM_VERSION >= 71100.
    # SMI is lazily dlopen'd at runtime; headers needed for the fabric probe.
    amdsmi
    fmt
    gtest
    roctracer
    rocprofiler
    rocprofiler-register
  ]
  ++ lib.optionals buildTests [
    chrpath
  ];

  cmakeFlags = [
    "-DHIP_CLANG_NUM_PARALLEL_JOBS=4"
    "-DROCM_PATH=${clr}"
    "-DHIP_COMPILER=${clr}/bin/amdclang++"
    "-DCMAKE_CXX_COMPILER=${clr}/bin/amdclang++"
    "-DROCM_PATCH_VERSION=${rocm-core.ROCM_LIBPATCH_VERSION}"
    "-DROCM_VERSION=${rocm-core.ROCM_LIBPATCH_VERSION}"
    "-DBUILD_BFD=OFF" # Can't get it to detect bfd.h
    "-DENABLE_MSCCL_KERNEL=ON"
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

  passthru.updateScript = rocmUpdateScript { inherit finalAttrs; };

  # This package with sanitizers + manual integration test binaries built
  # must be ran manually
  passthru.tests.rccl = rccl.override {
    buildTests = true;
  };

  meta = {
    description = "ROCm communication collectives library";
    homepage = "https://github.com/ROCm/rccl";
    license = with lib.licenses; [
      bsd2
      bsd3
    ];
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.linux;
  };
})
