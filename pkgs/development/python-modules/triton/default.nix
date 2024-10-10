{
  lib,
  buildPythonPackage,
  cmake,
  config,
  cudaPackages,
  fetchFromGitHub,
  filelock,
  gtest,
  libxml2,
  lit,
  llvm,
  ncurses,
  ninja,
  pybind11,
  python,
  runCommand,
  setuptools,
  torchWithRocm,
  zlib,
  cudaSupport ? config.cudaSupport,
}:

buildPythonPackage {
  pname = "triton";
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "triton-lang";
    repo = "triton";
    # latest branch commit from https://github.com/triton-lang/triton/commits/release/3.0.x/
    rev = "91f24d87e50cb748b121a6c24e65a01187699c22";
    hash = "sha256-L5KqiR+TgSyKjEBlkE0yOU1pemMHFk2PhEmxLdbbxUU=";
  };

  patches = [
    ./0001-setup.py-introduce-TRITON_OFFLINE_BUILD.patch
  ];

  postPatch =
    ''
      # Use our `cmakeFlags` instead and avoid downloading dependencies
      # remove any downloads
      substituteInPlace python/setup.py \
        --replace-fail "get_json_package_info(), get_pybind11_package_info()" ""\
        --replace-fail "get_pybind11_package_info(), get_llvm_package_info()" ""\
        --replace-fail 'packages += ["triton/profiler"]' ""\
        --replace-fail "curr_version != version" "False"

      # Don't fetch googletest
      substituteInPlace unittest/CMakeLists.txt \
        --replace-fail "include (\''${CMAKE_CURRENT_SOURCE_DIR}/googletest.cmake)" ""\
        --replace-fail "include(GoogleTest)" "find_package(GTest REQUIRED)"
    '';

  nativeBuildInputs = [
    setuptools
    # pytestCheckHook # Requires torch (circular dependency) and probably needs GPUs:
    cmake
    ninja

    # Note for future:
    # These *probably* should go in depsTargetTarget
    # ...but we cannot test cross right now anyway
    # because we only support cudaPackages on x86_64-linux atm
    lit
    llvm
  ];

  buildInputs = [
    gtest
    libxml2.dev
    ncurses
    pybind11
    zlib
  ];

  propagatedBuildInputs = [
    filelock
    # triton uses setuptools at runtime:
    # https://github.com/NixOS/nixpkgs/pull/286763/#discussion_r1480392652
    setuptools
  ];

  NIX_CFLAGS_COMPILE = lib.optionals cudaSupport [
    # Pybind11 started generating strange errors since python 3.12. Observed only in the CUDA branch.
    # https://gist.github.com/SomeoneSerge/7d390b2b1313957c378e99ed57168219#file-gistfile0-txt-L1042
    "-Wno-stringop-overread"
  ];

  # Avoid GLIBCXX mismatch with other cuda-enabled python packages
  preConfigure = ''
    # Ensure that the build process uses the requested number of cores
    export MAX_JOBS="$NIX_BUILD_CORES"

    # Upstream's setup.py tries to write cache somewhere in ~/
    export HOME=$(mktemp -d)

    # Upstream's github actions patch setup.cfg to write base-dir. May be redundant
    echo "
    [build_ext]
    base-dir=$PWD" >> python/setup.cfg

    # The rest (including buildPhase) is relative to ./python/
    cd python
  '';

  env = {
    TRITON_BUILD_PROTON = "OFF";
    TRITON_OFFLINE_BUILD = true;
  } // lib.optionalAttrs cudaSupport {
    CC = "${cudaPackages.backendStdenv.cc}/bin/cc";
    CXX = "${cudaPackages.backendStdenv.cc}/bin/c++";

    TRITON_PTXAS_PATH = lib.getExe' cudaPackages.cuda_nvcc "ptxas"; # Make sure cudaPackages is the right version each update (See python/setup.py)
    TRITON_CUOBJDUMP_PATH = cudaPackages.cuda_cuobjdump;
    TRITON_NVDISASM_PATH = cudaPackages.cuda_nvdisasm;
    TRITON_CUDACRT_PATH = cudaPackages.cuda_nvcc;
    TRITON_CUDART_PATH = cudaPackages.cuda_cudart;
    TRITON_CUPTI_PATH = cudaPackages.cuda_cupti;
  };

  # CMake is run by setup.py instead
  dontUseCmakeConfigure = true;
  checkInputs = [ cmake ]; # ctest
  dontUseSetuptoolsCheck = true;

  preCheck = ''
    # build/temp* refers to build_ext.build_temp (looked up in the build logs)
    (cd ./build/temp* ; ctest)

    # For pytestCheckHook
    cd test/unit
  '';

  # Circular dependency on torch
  # pythonImportsCheck = [
  #   "triton"
  #   "triton.language"
  # ];

  # Ultimately, torch is our test suite:
  passthru.tests = {
    inherit torchWithRocm;
    # Implemented as alternative to pythonImportsCheck, in case if circular dependency on torch occurs again,
    # and pythonImportsCheck is commented back.
    import-triton =
      runCommand "import-triton"
        { nativeBuildInputs = [ (python.withPackages (ps: [ ps.triton ])) ]; }
        ''
          python << \EOF
          import triton
          import triton.language
          EOF
          touch "$out"
        '';
  };

  pythonRemoveDeps = [
    # Circular dependency, cf. https://github.com/triton-lang/triton/issues/1374
    "torch"

    # CLI tools without dist-info
    "cmake"
    "lit"
  ];

  meta = with lib; {
    description = "Language and compiler for writing highly efficient custom Deep-Learning primitives";
    homepage = "https://github.com/triton-lang/triton";
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = with maintainers; [
      SomeoneSerge
      Madouura
      derdennisop
    ];
  };
}
