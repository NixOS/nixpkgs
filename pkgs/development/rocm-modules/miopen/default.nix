{
  lib,
  stdenv,
  callPackage,
  fetchFromGitHub,
  fetchpatch,
  fetchurl,
  runCommand,
  pkg-config,
  cmake,
  rocm-cmake,
  rocblas,
  rocmlir,
  rocrand,
  rocm-runtime,
  hipblas-common,
  hipblas,
  hipblaslt,
  clr,
  composable_kernel,
  frugally-deep,
  rocm-docs-core,
  half,
  boost,
  sqlite,
  symlinkJoin,
  bzip2,
  lbzip2,
  nlohmann_json,
  texliveSmall,
  doxygen,
  sphinx,
  zlib,
  zstd,
  gtest,
  rocm-comgr,
  roctracer,
  python3,
  python3Packages,
  gpuTargets ? clr.localGpuTargets or clr.gpuTargets,
  buildDocs ? false, # Needs internet because of rocm-docs-core
  buildTests ? false,
  withComposableKernel ? true,
}:

let
  # FIXME: cmake files need patched to include this properly
  # -Wno-covered-switch-default: MIOpen builds -Werror and the ROCm clang flags
  # nixpkgs nlohmann_json 3.12.0 switch(...) default labels. -isystem the
  # nlohmann headers so its header warnings are not treated as MIOpen -Werror errors.
  cFlags = "-Wno-documentation-pedantic -Wno-covered-switch-default --offload-compress -I${hipblas-common}/include -I${hipblas}/include -I${roctracer}/include -isystem ${nlohmann_json}/include -I${sqlite.dev}/include -I${rocrand}/include";
  version = "10.1";

  # Targets outside this list will get
  # error: use of undeclared identifier 'CK_BUFFER_RESOURCE_3RD_DWORD'
  supportedTargets = lib.intersectLists [
    "gfx900"
    "gfx906"
    "gfx908"
    "gfx90a"
    "gfx942"
    "gfx950"
    "gfx1030"
    "gfx1031"
    "gfx1100"
    "gfx1101"
    "gfx1102"
    "gfx1150"
    "gfx1151"
    "gfx1200"
    "gfx1201"
  ] gpuTargets;

  latex = lib.optionalAttrs buildDocs (
    texliveSmall.withPackages (
      ps: with ps; [
        latexmk
        tex-gyre
        fncychap
        wrapfig
        capt-of
        framed
        needspace
        tabulary
        varwidth
        titlesec
      ]
    )
  );

  # for hiprtcCompileProgram (dropout kernels require rocrand in -I at runtime)
  hiprtcCompileRocmPath = symlinkJoin {
    name = "miopen-hiprtc-compile-rocm-path";
    paths = [
      clr
      rocrand
    ];
  };

  # Kernel databases moved from Git LFS to DVC (anonymous s3 bucket s3://therock-dvc/rocm-libraries)
  fetchKdb =
    name:
    { url, hash }:
    runCommand "miopen-${name}.kdb" { preferLocalBuild = true; } ''
      ${lbzip2}/bin/lbzip2 -ckd ${
        fetchurl {
          inherit url hash;
          name = "${name}.kdb.bz2";
        }
      } > $out
    '';

  kdbs = lib.mapAttrs fetchKdb (
    lib.filterAttrs (name: _: lib.elem name supportedTargets) (import ./kdbs.nix)
  );

  linkKDBsTo =
    targetPath:
    lib.concatStringsSep "" (
      lib.mapAttrsToList (name: kdb: ''
        ln -sf ${kdb} ${targetPath}/${name}.kdb
      '') kdbs
    );
in
stdenv.mkDerivation (finalAttrs: {
  inherit version;
  pname = "miopen";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "rocm-libraries";
    tag = "therock-${finalAttrs.version}";
    sparseCheckout = [
      "projects/miopen"
      "shared"
    ];
    fetchSubmodules = true;
    hash = "sha256-pIo0QeVJ64Abte5u319kd2O6gjHIOtMkBo3h4thpzDo=";
  };
  sourceRoot = "${finalAttrs.src.name}/projects/miopen";

  env.CFLAGS = cFlags;
  env.CXXFLAGS = cFlags;

  patches = [
    ./skip-preexisting-dbs.patch
    # Extend MIOpen's HIP ISA compatibility check (e.g. gfx906 code objects on
    # gfx90c-class devices). Rebased from GZGavinZhao/MIOpen 02f0fedf.
    ./extend-miopen-isa-compatibility.patch
  ];

  outputs = [
    "out"
  ]
  ++ lib.optionals buildDocs [
    "doc"
  ]
  ++ lib.optionals buildTests [
    "test"
  ];
  enableParallelBuilding = true;
  env.ROCM_PATH = clr;
  env.LD_LIBRARY_PATH = lib.makeLibraryPath [ rocm-runtime ];

  nativeBuildInputs = [
    pkg-config
    cmake
    rocm-cmake
    # cmake/CopyExternalHeader.cmake does find_package(Python3 REQUIRED)
    python3
    clr
  ];

  buildInputs = [
    hipblas
    hipblas-common
    rocblas
    rocmlir
    half
    boost
    sqlite
    bzip2
    zstd
    nlohmann_json
    frugally-deep
    roctracer
    rocrand
    hipblaslt
  ]
  ++ lib.optionals withComposableKernel [
    composable_kernel
  ]
  ++ lib.optionals buildDocs [
    latex
    doxygen
    sphinx
    rocm-docs-core
    python3Packages.sphinx-rtd-theme
    python3Packages.breathe
    python3Packages.myst-parser
  ]
  ++ lib.optionals buildTests [
    gtest
    zlib
  ];

  cmakeFlags = [
    # MIOpen defaults MIOPEN_STANDALONE_BUILD=ON (when no toolchain
    # file is set, as here), which FetchContents Eigen/nlohmann_json/frugally-deep/
    # bzip2/sqlite/gtest at configure — blocked in the Nix sandbox. Turn it OFF and
    # rely on the deps provided via buildInputs (find_package resolves them).
    (lib.cmakeBool "MIOPEN_STANDALONE_BUILD" false)
    "-DAMDGPU_TARGETS=${lib.concatStringsSep ";" supportedTargets}"
    "-DGPU_TARGETS=${lib.concatStringsSep ";" supportedTargets}"
    "-DGPU_ARCHS=${lib.concatStringsSep ";" supportedTargets}"
    "-DCMAKE_VERBOSE_MAKEFILE=ON"
    "-DCMAKE_MODULE_PATH=${clr}/hip/cmake"

    # needs to stream to stdout so bzcat rather than bunzip2
    "-DUNZIPPER=${bzip2}/bin/bzcat"

    "-DCMAKE_C_COMPILER=amdclang"
    "-DCMAKE_CXX_COMPILER=amdclang++"
    "-DROCM_PATH=${clr}"
    "-DHIP_ROOT_DIR=${clr}"
    (lib.cmakeBool "MIOPEN_USE_ROCBLAS" true)
    (lib.cmakeBool "MIOPEN_USE_HIPBLASLT" true)
    (lib.cmakeBool "MIOPEN_USE_COMPOSABLEKERNEL" withComposableKernel)
    (lib.cmakeBool "MIOPEN_USE_HIPRTC" true)
    (lib.cmakeBool "MIOPEN_USE_COMGR" true)
    # Disable the vendored `hipconv` convolution subsystem (new in 10.1). It serves
    # only cdna3/cdna4/cdna5 (gfx942/gfx950 and newer). Its CMake unconditionally
    # compiles every arch dir under src/hipconv/src/arch/*, and the cdna4
    # `direct_wgrad` kernels do not compile with clang 24, which rejects their
    # `static constexpr` members and `constexpr` variable templates as "reference to
    # __host__ variable in __device__ function". conv_hipconv.cpp self-guards on
    # MIOPEN_USE_HIPCONV, so other targets are unaffected. Re-enable once the
    # kernels build with clang 24.
    (lib.cmakeBool "MIOPEN_USE_HIPCONV" false)
    "-DCMAKE_HIP_COMPILER_ROCM_ROOT=${clr}"
    # Manually define CMAKE_INSTALL_<DIR>
    # See: https://github.com/NixOS/nixpkgs/pull/197838
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DMIOPEN_BACKEND=HIP"
  ]
  ++ lib.optionals buildTests [
    "-DBUILD_TESTS=ON"
    "-DMIOPEN_TEST_ALL=ON"
  ];

  postPatch = ''
    # MIOpen forces its own cmake/ClangToolChain.cmake as
    # CMAKE_TOOLCHAIN_FILE when the caller passes none, which overrides the
    # nixpkgs rocmClangStdenv compiler setup and leaves CMAKE_MAKE_PROGRAM unset.
    # Disable that auto-set (the else branch then also makes the standalone
    # default OFF, matching -DMIOPEN_STANDALONE_BUILD=OFF).
    substituteInPlace CMakeLists.txt \
      --replace-fail 'if(NOT CMAKE_TOOLCHAIN_FILE AND NOT DEFINED ENV{CMAKE_TOOLCHAIN_FILE})' 'if(FALSE)'

    # MIOpen builds -Werror, but the ROCm 10 clang + C++20
    # emit new warnings from MIOpen's own code and newer standard/3rd-party headers
    # (e.g. <ciso646> deprecation, covered-switch-default). Downgrade -Werror rather
    # than chase each warning (matches how composable_kernel neutralises -Werror).
    substituteInPlace cmake/EnableCompilerWarnings.cmake \
      --replace-fail '    -Werror' '    -Wno-error'

    substituteInPlace cmake/ClangTidy.cmake \
      --replace-fail 'macro(enable_clang_tidy)' 'macro(enable_clang_tidy)
      endmacro()
      macro(enable_clang_tidy_unused)' \
      --replace-fail 'function(clang_tidy_check TARGET)' 'function(clang_tidy_check TARGET)
      return()'

    patchShebangs test fin utils install_deps.cmake

    # comgr.cpp reads the ROCM_PATH env var (no more /opt/rocm
    # hardcode) and adds no include path when it is unset. Bake our curated
    # hiprtc ROCm tree in as the fallback so runtime hiprtc kernel compilation
    # (e.g. from torch) still finds ROCm headers when ROCM_PATH is not exported.
    substituteInPlace src/comgr.cpp \
      --replace-fail 'auto rocm_path = env::value(ROCM_PATH);' 'auto rocm_path = env::value(ROCM_PATH);
        if(rocm_path.empty())
            rocm_path = "${hiprtcCompileRocmPath}";'
  ''
  + linkKDBsTo "src/kernels"
  + ''
    mkdir -p build/share/miopen/db/
  ''
  + linkKDBsTo "build/share/miopen/db";

  # Unfortunately, it seems like we have to call make on these manually
  postBuild =
    lib.optionalString buildDocs ''
      python -m sphinx -T -E -b html -d _build/doctrees -D language=en ../docs _build/html
    ''
    + lib.optionalString buildTests ''
      make -j$NIX_BUILD_CORES check
    '';

  postInstall = ''
    rm $out/libexec/miopen/install_precompiled_kernels.sh
  ''
  + linkKDBsTo "$out/share/miopen/db"
  + lib.optionalString buildDocs ''
    mv ../doc/html $out/share/doc/miopen-hip
  ''
  + lib.optionalString buildTests ''
    mkdir -p $test/bin
    mv bin/test_* $test/bin
    patchelf --set-rpath $out/lib:${
      lib.makeLibraryPath (
        finalAttrs.buildInputs
        ++ [
          clr
          rocm-comgr
        ]
      )
    } $test/bin/*
  '';

  requiredSystemFeatures = [ "big-parallel" ];

  passthru.impureTests = {
    # bash $(nix-build -A rocmPackages.miopen.passthru.impureTests.conv) etc
    bnorm = callPackage ./test-runtime-compilation.nix {
      miopen = finalAttrs.finalPackage;
      name = "bnorm";
      testScript = "MIOpenDriver bnorm -n 16 -c 16 -H 512 -W 512 -m 1 -F 1 -s 1 -r 1";
    };
    conv = callPackage ./test-runtime-compilation.nix {
      miopen = finalAttrs.finalPackage;
      name = "conv";
      testScript = "MIOpenDriver conv -n 1 -c 1 -H 4 -W 4 -k 1 -y 3 -x 3 -p 0 -q 0 -V 0";
    };
    dropout = callPackage ./test-runtime-compilation.nix {
      miopen = finalAttrs.finalPackage;
      name = "dropout";
      testScript = "MIOpenDriver dropout -d 64,32,14,14";
    };
    pool = callPackage ./test-runtime-compilation.nix {
      miopen = finalAttrs.finalPackage;
      name = "pool";
      testScript = "MIOpenDriver pool -W 1x1x4x4 -y 2 -x 2 -p 0 -q 0 -F 1 -V 0";
    };
  };
  passthru.tests = {
    # Ensure all .tn.model files can be loaded by whatever version of frugally-deep we have
    # This is otherwise hard to verify as MIOpen will only use these models on specific,
    # expensive Instinct GPUs
    # If MIOpen stops embedding .tn.model files the test will also fail, and can be deleted,
    # likely along with the frugally-deep dependency
    can-load-models = callPackage ./test-frugally-deep-model-loading.nix {
      inherit (finalAttrs) src version;
      inherit frugally-deep nlohmann_json;
    };
  };
  passthru.updateScript = ./update.sh;

  meta = {
    description = "Machine intelligence library for ROCm";
    homepage = "https://github.com/ROCm/rocm-libraries/tree/develop/projects/miopen";
    license = lib.licenses.mit;
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.linux;
  };
})
