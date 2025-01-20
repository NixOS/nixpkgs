{
  lib,
  stdenv,
  fetchFromGitHub,
  rocmUpdateScript,
  cmake,
  rocm-cmake,
  rocm-smi,
  rocm-core,
  clr,
  mscclpp,
  perl,
  hipify,
  gtest,
  chrpath,
  rocprofiler,
  rocprofiler-register,
  autoPatchelfHook,
  buildTests ? false,
  gpuTargets ? (clr.localGpuTargets or [ ]),
}:

let
  useAsan = buildTests;
  useUbsan = buildTests;
  san = lib.optionalString (useAsan || useUbsan) (
    "-fno-gpu-sanitize -fsanitize=undefined "
    + (lib.optionalString useAsan "-fsanitize=address -shared-libsan ")
  );
in
# FIXME: infiniband support relies on:
# * kfd_peerdirect support which is on out-of-tree amdkfd in ROCm/ROCK-Kernel-Driver
# * ib_peer_mem support which is ??? and ubuntu has a patchset here https://git.launchpad.net/~ubuntu-kernel/ubuntu/+source/linux/+git/hirsute/commit/?id=e9eb90eb5e4a5aef6f516abbc720038fc0d1a139
stdenv.mkDerivation (finalAttrs: {
  pname = "rccl${clr.gpuArchSuffix}";
  version = "6.3.1";

  outputs =
    [
      "out"
    ]
    ++ lib.optionals buildTests [
      "test"
    ];

  patches = [
    ./fix-mainline-support-and-ub.diff
    ./enable-mscclpp-on-all-gfx9.diff
    ./rccl-test-missing-iomanip.diff
  ];

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "rccl";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-61yvFqloOO6qtn0H6XsAPvJ6LKlOeXgTD/xbjCuB3zQ=";
  };

  nativeBuildInputs = [
    cmake
    rocm-cmake
    clr
    perl
    hipify
    autoPatchelfHook # ASAN doesn't add rpath without this
  ];

  buildInputs =
    [
      rocm-smi
      gtest
      rocprofiler
      rocprofiler-register
      mscclpp
    ]
    ++ lib.optionals buildTests [
      chrpath
    ];

  cmakeFlags =
    [
      "-DCMAKE_BUILD_TYPE=Release"
      "-DROCM_PATH=${clr}"
      "-DHIP_COMPILER=${clr}/bin/amdclang++"
      "-DCMAKE_CXX_COMPILER=${clr}/bin/amdclang++"
      "-DROCM_PATCH_VERSION=${rocm-core.ROCM_LIBPATCH_VERSION}"
      "-DROCM_VERSION=${rocm-core.ROCM_LIBPATCH_VERSION}"
      "-DBUILD_BFD=OFF" # Can't get it to detect bfd.h
      "-DENABLE_MSCCL_KERNEL=ON"
      "-DENABLE_MSCCLPP=ON"
      "-DMSCCLPP_ROOT=${mscclpp}"
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
  makeFlags = [ "-l32" ];

  env.CCC_OVERRIDE_OPTIONS = "+-parallel-jobs=6";
  # -O2 and -fno-strict-aliasing due to UB issues in RCCL :c
  # Reported upstream
  env.CFLAGS = "-I${clr}/include -O2 -fno-strict-aliasing ${san}-fno-omit-frame-pointer -momit-leaf-frame-pointer";
  env.CXXFLAGS = "-I${clr}/include -O2 -fno-strict-aliasing ${san}-fno-omit-frame-pointer -momit-leaf-frame-pointer";
  env.LDFLAGS = "${san}";
  postPatch = ''
    patchShebangs src tools

    # Really strange behavior, `#!/usr/bin/env perl` should work...
    substituteInPlace CMakeLists.txt \
      --replace "\''$ \''${hipify-perl_executable}" "${perl}/bin/perl ${hipify}/bin/hipify-perl"
  '';

  postInstall =
    lib.optionalString useAsan ''
      patchelf --add-needed ${clr}/llvm/lib/linux/libclang_rt.asan-x86_64.so $out/lib/librccl.so
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

  meta = with lib; {
    description = "ROCm communication collectives library";
    homepage = "https://github.com/ROCm/rccl";
    license = with licenses; [
      bsd2
      bsd3
    ];
    maintainers = teams.rocm.members;
    platforms = platforms.linux;
  };
})
