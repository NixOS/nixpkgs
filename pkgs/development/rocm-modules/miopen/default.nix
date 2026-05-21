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
  gtest,
  rocm-comgr,
  roctracer,
  python3Packages,
  gpuTargets ? clr.localGpuTargets or clr.gpuTargets,
  buildDocs ? false, # Needs internet because of rocm-docs-core
  buildTests ? false,
  withComposableKernel ? true,
}:

let
  # FIXME: cmake files need patched to include this properly
  cFlags = "-Wno-documentation-pedantic --offload-compress -I${hipblas-common}/include -I${hipblas}/include -I${roctracer}/include -I${nlohmann_json}/include -I${sqlite.dev}/include -I${rocrand}/include";
  version = "7.2.3";

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
    rev = "rocm-${finalAttrs.version}";
    sparseCheckout = [
      "projects/miopen"
      "shared"
    ];
    fetchSubmodules = true;
    hash = "sha256-plZpBTbEBVMa5CasjfbUsu45xP/BYstrEpWKK2H7QQ4=";
  };
  sourceRoot = "${finalAttrs.src.name}/projects/miopen";

  env.CFLAGS = cFlags;
  env.CXXFLAGS = cFlags;

  # Find zstd and add to target. Mainly for torch.
  patches = [
    ./skip-preexisting-dbs.patch
    (fetchpatch {
      url = "https://github.com/ROCm/MIOpen/commit/e608b4325646afeabb5e52846997b926d2019d19.patch";
      hash = "sha256-oxa3qlIC2bzbwGxrQOZXoY/S7CpLsMrnWRB7Og0tk0M=";
    })
    (fetchpatch {
      url = "https://github.com/ROCm/MIOpen/commit/3413d2daaeb44b7d6eadcc03033a5954a118491e.patch";
      hash = "sha256-ST4snUcTmmSI1Ogx815KEX9GdMnmubsavDzXCGJkiKs=";
    })
    (fetchpatch {
      # [miopen] Extend HIP ISA compatibility
      name = "Extend-MIOpen-ISA-compatibility.patch";
      url = "https://github.com/GZGavinZhao/rocm-libraries/commit/02f0fedffdc197f146dd45f41e10990a00cde3ee.patch";
      hash = "sha256-My32iZw75rvB4fyvUJJ2kw2bU9/39awGteFGjzijixw=";
      relative = "projects/miopen";
    })
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
    "-DAMDGPU_TARGETS=${lib.concatStringsSep ";" supportedTargets}"
    "-DGPU_TARGETS=${lib.concatStringsSep ";" supportedTargets}"
    "-DGPU_ARCHS=${lib.concatStringsSep ";" supportedTargets}"
    "-DCMAKE_VERBOSE_MAKEFILE=ON"
    "-DCMAKE_MODULE_PATH=${clr}/hip/cmake"
    "-DCMAKE_BUILD_TYPE=Release"

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
    substituteInPlace cmake/ClangTidy.cmake \
      --replace-fail 'macro(enable_clang_tidy)' 'macro(enable_clang_tidy)
      endmacro()
      macro(enable_clang_tidy_unused)' \
      --replace-fail 'function(clang_tidy_check TARGET)' 'function(clang_tidy_check TARGET)
      return()'

    patchShebangs test src/composable_kernel fin utils install_deps.cmake

    substituteInPlace src/comgr.cpp \
      --replace-fail '"/opt/rocm"' '"${hiprtcCompileRocmPath}"'
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
    license = with lib.licenses; [ mit ];
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.linux;
  };
})
