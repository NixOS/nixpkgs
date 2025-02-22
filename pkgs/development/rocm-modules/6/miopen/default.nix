{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  rocmUpdateScript,
  runCommand,
  pkg-config,
  cmake,
  rocm-cmake,
  rocblas,
  rocmlir,
  rocrand,
  rocm-runtime,
  rocm-merged-llvm,
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
  # FIXME: should be able to use all clr targets
  gpuTargets ? [
    "gfx908"
    "gfx90a"
    "gfx942"
    "gfx1030"
    "gfx1100"
  ], # clr.gpuTargets
  buildDocs ? false, # Needs internet because of rocm-docs-core
  buildTests ? false,
}:

let
  # FIXME: cmake files need patched to include this properly
  cFlags = "-O3 -DNDEBUG -Wno-documentation-pedantic --offload-compress -I${hipblas-common}/include  -I${hipblas}/include -I${roctracer}/include -I${nlohmann_json}/include -I${sqlite.dev}/include -I${rocrand}/include";
  version = "6.3.1";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "MIOpen";
    rev = "rocm-${version}";
    hash = "sha256-KV+tJPD4HQayY8zD4AdOFxxYRnyI47suxX5OgZ7mpdU=";
    fetchLFS = true;
    fetchSubmodules = true;
    # WORKAROUND: .lfsconfig is incorrectly set to exclude everything upstream
    leaveDotGit = true;
    postFetch = ''
      export HOME=$(mktemp -d)
      cd $out
      set -x
      git remote add origin $url
      git fetch origin +refs/tags/rocm-${version}:refs/tags/rocm-${version}
      git clean -fdx
      git switch -c rocm-${version} refs/tags/rocm-${version}
      git config lfs.fetchexclude "none"
      rm .lfsconfig
      git lfs install
      git lfs track "*.kdb.bz2"
      GIT_TRACE=1 git lfs fetch --include="src/kernels/**"
      GIT_TRACE=1 git lfs pull --include="src/kernels/**"
      git lfs checkout

      rm -rf .git
    '';
  };

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

  gfx900 = runCommand "miopen-gfx900.kdb" { preferLocalBuild = true; } ''
    ${lbzip2}/bin/lbzip2 -ckd ${src}/src/kernels/gfx900.kdb.bz2 > $out
  '';

  gfx906 = runCommand "miopen-gfx906.kdb" { preferLocalBuild = true; } ''
    ${lbzip2}/bin/lbzip2 -ckd ${src}/src/kernels/gfx906.kdb.bz2 > $out
  '';

  gfx908 = runCommand "miopen-gfx908.kdb" { preferLocalBuild = true; } ''
    ${lbzip2}/bin/lbzip2 -ckd ${src}/src/kernels/gfx908.kdb.bz2 > $out
  '';

  gfx90a = runCommand "miopen-gfx90a.kdb" { preferLocalBuild = true; } ''
    ${lbzip2}/bin/lbzip2 -ckd ${src}/src/kernels/gfx90a.kdb.bz2 > $out
  '';

  gfx1030 = runCommand "miopen-gfx1030.kdb" { preferLocalBuild = true; } ''
    ${lbzip2}/bin/lbzip2 -ckd ${src}/src/kernels/gfx1030.kdb.bz2 > $out
  '';
in
stdenv.mkDerivation (finalAttrs: {
  inherit version src;
  pname = "miopen";

  env.CFLAGS = cFlags;
  env.CXXFLAGS = cFlags;

  preConfigure = ''
    makeFlagsArray+=("-l$(nproc)")
  '';
  # Find zstd and add to target. Mainly for torch.
  patches = [
    ./skip-preexisting-dbs.patch
    ./fix-isnan.patch # https://github.com/ROCm/MIOpen/pull/3448
    (fetchpatch {
      url = "https://github.com/ROCm/MIOpen/commit/e608b4325646afeabb5e52846997b926d2019d19.patch";
      hash = "sha256-oxa3qlIC2bzbwGxrQOZXoY/S7CpLsMrnWRB7Og0tk0M=";
    })
    (fetchpatch {
      url = "https://github.com/ROCm/MIOpen/commit/3413d2daaeb44b7d6eadcc03033a5954a118491e.patch";
      hash = "sha256-ST4snUcTmmSI1Ogx815KEX9GdMnmubsavDzXCGJkiKs=";
    })
    # (fetchpatch {
    #   name = "Extend-MIOpen-ISA-compatibility.patch";
    #   url = "https://github.com/GZGavinZhao/MIOpen/commit/416088b534618bd669a765afce59cfc7197064c1.patch";
    #   hash = "sha256-OwONCA68y8s2GqtQj+OtotXwUXQ5jM8tpeM92iaD4MU=";
    # })
  ];

  outputs =
    [
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
  env.HIP_CLANG_PATH = "${rocm-merged-llvm}/bin";

  nativeBuildInputs = [
    pkg-config
    cmake
    rocm-cmake
    clr
  ];

  buildInputs =
    [
      hipblas
      hipblas-common
      rocblas
      rocmlir
      composable_kernel
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

  cmakeFlags =
    [
      "-DAMDGPU_TARGETS=${lib.concatStringsSep ";" gpuTargets}"
      "-DGPU_TARGETS=${lib.concatStringsSep ";" gpuTargets}"
      "-DGPU_ARCHS=${lib.concatStringsSep ";" gpuTargets}"
      "-DMIOPEN_USE_SQLITE_PERFDB=ON"
      "-DCMAKE_VERBOSE_MAKEFILE=ON"
      "-DCMAKE_MODULE_PATH=${clr}/hip/cmake"
      "-DCMAKE_BUILD_TYPE=Release"

      # needs to stream to stdout so bzcat rather than bunzip2
      "-DUNZIPPER=${bzip2}/bin/bzcat"

      # isnan not defined for float error, probably still needs hipcc? should try without hipcc again next bump
      "-DCMAKE_C_COMPILER=amdclang"
      "-DCMAKE_CXX_COMPILER=amdclang++"
      "-DROCM_PATH=${clr}"
      "-DHIP_ROOT_DIR=${clr}"
      (lib.cmakeBool "MIOPEN_USE_ROCBLAS" true)
      (lib.cmakeBool "MIOPEN_USE_HIPBLASLT" true)
      (lib.cmakeBool "MIOPEN_USE_COMPOSABLEKERNEL" true)
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
    echo "HACK: disabling clang-tidy"
    substituteInPlace cmake/ClangTidy.cmake \
      --replace-fail 'macro(enable_clang_tidy)' 'macro(enable_clang_tidy)
      endmacro()
      macro(enable_clang_tidy_unused)' \
      --replace-fail 'function(clang_tidy_check TARGET)' 'function(clang_tidy_check TARGET)
      return()'

    patchShebangs test src/composable_kernel fin utils install_deps.cmake

      #--replace "unpack_db(\"\''${CMAKE_SOURCE_DIR}/src/kernels/\''${FILE_NAME}.kdb.bz2\")" "" \
    # substituteInPlace CMakeLists.txt \
    #   --replace "MIOPEN_HIP_COMPILER MATCHES \".*clang\\\\+\\\\+$\"" "true" \
    #   --replace "set(MIOPEN_TIDY_ERRORS ALL)" "" # error: missing required key 'key'

    substituteInPlace test/gtest/CMakeLists.txt \
      --replace "include(googletest)" ""

    # substituteInPlace test/gtest/CMakeLists.txt \
    #   --replace-fail " gtest_main " " ${gtest}/lib/libgtest.so ${gtest}/lib/libgtest_main.so "

    ln -sf ${gfx900} src/kernels/gfx900.kdb
    ln -sf ${gfx906} src/kernels/gfx906.kdb
    ln -sf ${gfx908} src/kernels/gfx908.kdb
    ln -sf ${gfx90a} src/kernels/gfx90a.kdb
    ln -sf ${gfx1030} src/kernels/gfx1030.kdb
    mkdir -p build/share/miopen/db/
    ln -sf ${gfx900} build/share/miopen/db/gfx900.kdb
    ln -sf ${gfx906} build/share/miopen/db/gfx906.kdb
    ln -sf ${gfx908} build/share/miopen/db/gfx908.kdb
    ln -sf ${gfx90a} build/share/miopen/db/gfx90a.kdb
    ln -sf ${gfx1030} build/share/miopen/db/gfx1030.kdb
  '';

  # Unfortunately, it seems like we have to call make on these manually
  postBuild =
    lib.optionalString buildDocs ''
      python -m sphinx -T -E -b html -d _build/doctrees -D language=en ../docs _build/html
    ''
    + lib.optionalString buildTests ''
      make -j$NIX_BUILD_CORES check
    '';

  postInstall =
    ''
      rm $out/bin/install_precompiled_kernels.sh
      ln -sf ${gfx900} $out/share/miopen/db/gfx900.kdb
      ln -sf ${gfx906} $out/share/miopen/db/gfx906.kdb
      ln -sf ${gfx908} $out/share/miopen/db/gfx908.kdb
      ln -sf ${gfx90a} $out/share/miopen/db/gfx90a.kdb
      ln -sf ${gfx1030} $out/share/miopen/db/gfx1030.kdb
    ''
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
  # doCheck = false; # FIXME: clang-tidy really slow :(

  requiredSystemFeatures = [ "big-parallel" ];

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    inherit (finalAttrs.src) owner;
    inherit (finalAttrs.src) repo;
  };

  meta = with lib; {
    description = "Machine intelligence library for ROCm";
    homepage = "https://github.com/ROCm/MIOpen";
    license = with licenses; [ mit ];
    maintainers = teams.rocm.members;
    platforms = platforms.linux;
  };
})
