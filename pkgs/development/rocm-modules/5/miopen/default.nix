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
  clr,
  clang-tools-extra,
  clang-ocl,
  miopengemm,
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
  python3Packages,
  buildDocs ? false, # Needs internet because of rocm-docs-core
  buildTests ? false,
  useOpenCL ? false,
}:

let
  version = "5.7.1";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "MIOpen";
    rev = "rocm-${version}";
    hash = "sha256-xcKmFI8HcRA9bbh6EQGElKykIQ3RJX/q5f4IxXvM1Is=";
    fetchLFS = true;
    leaveDotGit = true;

    # If you're reading this, it's gonna take a bit of time.
    # fetchSubModules doesn't work with postFetch???
    # fetchLFS isn't actually fetching the LFS files...
    postFetch = ''
      export HOME=$(mktemp -d)
      cd $out

      # We need more history to fetch LFS files
      git remote add origin $url
      git fetch origin
      git clean -fdx
      git checkout rocm-${version}

      # We need to do this manually since using leaveDotGit and fetchSubmodules errors
      git submodule update --init

      # Fetch the LFS files
      git lfs install
      git lfs fetch --all
      git lfs checkout

      # Remove the defunct .git folder
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

  # Find zstd and add to target. Mainly for torch.
  patches = [
    (fetchpatch {
      url = "https://github.com/ROCm/MIOpen/commit/e608b4325646afeabb5e52846997b926d2019d19.patch";
      hash = "sha256-oxa3qlIC2bzbwGxrQOZXoY/S7CpLsMrnWRB7Og0tk0M=";
    })
    (fetchpatch {
      url = "https://github.com/ROCm/MIOpen/commit/3413d2daaeb44b7d6eadcc03033a5954a118491e.patch";
      hash = "sha256-ST4snUcTmmSI1Ogx815KEX9GdMnmubsavDzXCGJkiKs=";
    })
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

  nativeBuildInputs = [
    pkg-config
    cmake
    rocm-cmake
    clr
    clang-tools-extra
  ];

  buildInputs =
    [
      rocblas
      rocmlir
      clang-ocl
      miopengemm
      composable_kernel
      half
      boost
      sqlite
      bzip2
      nlohmann_json
      frugally-deep
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
      "-DCMAKE_CXX_FLAGS=-Wno-#warnings" # <half> -> <half/half.hpp>
      "-DMIOPEN_USE_MIOPENGEMM=ON"
      "-DUNZIPPER=${bzip2}/bin/bunzip2"
      # Manually define CMAKE_INSTALL_<DIR>
      # See: https://github.com/NixOS/nixpkgs/pull/197838
      "-DCMAKE_INSTALL_BINDIR=bin"
      "-DCMAKE_INSTALL_LIBDIR=lib"
      "-DCMAKE_INSTALL_INCLUDEDIR=include"
    ]
    ++ lib.optionals (!useOpenCL) [
      "-DCMAKE_C_COMPILER=hipcc"
      "-DCMAKE_CXX_COMPILER=hipcc"
      "-DMIOPEN_BACKEND=HIP"
    ]
    ++ lib.optionals useOpenCL [
      "-DMIOPEN_BACKEND=OpenCL"
    ]
    ++ lib.optionals buildTests [
      "-DBUILD_TESTS=ON"
      "-DMIOPEN_TEST_ALL=ON"
    ];

  postPatch = ''
    patchShebangs test src/composable_kernel fin utils install_deps.cmake

    substituteInPlace CMakeLists.txt \
      --replace "unpack_db(\"\''${CMAKE_SOURCE_DIR}/src/kernels/\''${FILE_NAME}.kdb.bz2\")" "" \
      --replace "MIOPEN_HIP_COMPILER MATCHES \".*clang\\\\+\\\\+$\"" "true" \
      --replace "set(MIOPEN_TIDY_ERRORS ALL)" "" # error: missing required key 'key'

    substituteInPlace test/gtest/CMakeLists.txt \
      --replace "include(googletest)" ""

    substituteInPlace test/gtest/CMakeLists.txt \
      --replace-fail " gtest_main " " ${gtest}/lib/libgtest.so ${gtest}/lib/libgtest_main.so "

    ln -sf ${gfx900} src/kernels/gfx900.kdb
    ln -sf ${gfx906} src/kernels/gfx906.kdb
    ln -sf ${gfx908} src/kernels/gfx908.kdb
    ln -sf ${gfx90a} src/kernels/gfx90a.kdb
    ln -sf ${gfx1030} src/kernels/gfx1030.kdb
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
      mv ../doc/html $out/share/doc/miopen-${if useOpenCL then "opencl" else "hip"}
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

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    owner = finalAttrs.src.owner;
    repo = finalAttrs.src.repo;
  };

  meta = with lib; {
    description = "Machine intelligence library for ROCm";
    homepage = "https://github.com/ROCm/MIOpen";
    license = with licenses; [ mit ];
    maintainers = teams.rocm.members;
    platforms = platforms.linux;
    broken =
      versions.minor finalAttrs.version != versions.minor stdenv.cc.version
      || versionAtLeast finalAttrs.version "6.0.0";
  };
})
