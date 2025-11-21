{
  lib,
  stdenv,
  config,
  buildPythonPackage,
  fetchFromGitHub,

  # patches
  replaceVars,
  addDriverRunpath,
  cudaPackages,

  # build-system
  setuptools,

  # nativeBuildInputs
  cmake,
  ninja,
  lit,
  llvm,
  writableTmpDirAsHomeHook,

  # buildInputs
  gtest,
  libxml2,
  ncurses,
  pybind11,
  zlib,

  # dependencies
  filelock,

  # passthru
  python,
  pytestCheckHook,
  torchWithRocm,
  runCommand,
  triton,
  rocmPackages,

  cudaSupport ? config.cudaSupport,
}:

buildPythonPackage rec {
  pname = "triton";
  version = "3.5.1";
  pyproject = true;

  # Remember to bump triton-llvm as well!
  src = fetchFromGitHub {
    owner = "triton-lang";
    repo = "triton";
    tag = "v${version}";
    hash = "sha256-dyNRtS1qtU8C/iAf0Udt/1VgtKGSvng1+r2BtvT9RB4=";
  };

  patches = [
    (replaceVars ./0001-_build-allow-extra-cc-flags.patch {
      ccCmdExtraFlags = "-Wl,-rpath,${addDriverRunpath.driverLink}/lib";
    })
    (replaceVars ./0002-nvidia-driver-short-circuit-before-ldconfig.patch {
      libcudaStubsDir =
        if cudaSupport then "${lib.getOutput "stubs" cudaPackages.cuda_cudart}/lib/stubs" else null;
    })
  ]
  ++ lib.optionals cudaSupport [
    (replaceVars ./0003-nvidia-cudart-a-systempath.patch {
      cudaToolkitIncludeDirs = "${lib.getInclude cudaPackages.cuda_cudart}/include";
    })
    (replaceVars ./0004-nvidia-allow-static-ptxas-path.patch {
      nixpkgsExtraBinaryPaths = lib.escapeShellArgs [ (lib.getExe' cudaPackages.cuda_nvcc "ptxas") ];
    })
  ];

  postPatch =
    # Allow CMake 4
    # Upstream issue: https://github.com/triton-lang/triton/issues/8245
    ''
      substituteInPlace pyproject.toml \
        --replace-fail "cmake>=3.20,<4.0" "cmake>=3.20"
    ''
    # Avoid downloading dependencies remove any downloads
    + ''
      substituteInPlace setup.py \
        --replace-fail "[get_json_package_info()]" "[]" \
        --replace-fail "[get_llvm_package_info()]" "[]" \
        --replace-fail 'yield ("triton.profiler", "third_party/proton/proton")' 'pass' \
        --replace-fail "curr_version.group(1) != version" "False"
    ''
    # Use our `cmakeFlags` instead and avoid downloading dependencies
    + ''
      substituteInPlace setup.py \
        --replace-fail \
          "cmake_args.extend(thirdparty_cmake_args)" \
          "cmake_args.extend(thirdparty_cmake_args + os.environ.get('cmakeFlags', \"\").split())"
    ''
    # Don't fetch googletest
    + ''
      substituteInPlace cmake/AddTritonUnitTest.cmake \
        --replace-fail "include(\''${PROJECT_SOURCE_DIR}/unittest/googletest.cmake)" ""\
        --replace-fail "include(GoogleTest)" "find_package(GTest REQUIRED)"
    '';

  build-system = [ setuptools ];

  nativeBuildInputs = [
    cmake
    ninja

    # Note for future:
    # These *probably* should go in depsTargetTarget
    # ...but we cannot test cross right now anyway
    # because we only support cudaPackages on x86_64-linux atm
    lit
    llvm

    # Upstream's setup.py tries to write cache somewhere in ~/
    writableTmpDirAsHomeHook
  ];

  cmakeFlags = [
    (lib.cmakeFeature "LLVM_SYSPATH" "${llvm}")

    # `find_package` is called with `NO_DEFAULT_PATH`
    # https://cmake.org/cmake/help/latest/command/find_package.html
    # https://github.com/triton-lang/triton/blob/c3c476f357f1e9768ea4e45aa5c17528449ab9ef/third_party/amd/CMakeLists.txt#L6
    (lib.cmakeFeature "LLD_DIR" "${lib.getLib llvm}")
  ];

  buildInputs = [
    gtest
    libxml2.dev
    ncurses
    pybind11
    zlib
  ];

  dependencies = [
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

  preConfigure =
    # Ensure that the build process uses the requested number of cores
    ''
      export MAX_JOBS="$NIX_BUILD_CORES"
    '';

  env = {
    TRITON_BUILD_PROTON = "OFF";
    TRITON_OFFLINE_BUILD = true;
  }
  // lib.optionalAttrs cudaSupport {
    CC = lib.getExe' cudaPackages.backendStdenv.cc "cc";
    CXX = lib.getExe' cudaPackages.backendStdenv.cc "c++";

    # TODO: Unused because of how TRITON_OFFLINE_BUILD currently works (subject to change)
    TRITON_PTXAS_PATH = lib.getExe' cudaPackages.cuda_nvcc "ptxas"; # Make sure cudaPackages is the right version each update (See python/setup.py)
    TRITON_CUOBJDUMP_PATH = lib.getExe' cudaPackages.cuda_cuobjdump "cuobjdump";
    TRITON_NVDISASM_PATH = lib.getExe' cudaPackages.cuda_nvdisasm "nvdisasm";
    TRITON_CUDACRT_PATH = lib.getInclude cudaPackages.cuda_nvcc;
    TRITON_CUDART_PATH = lib.getInclude cudaPackages.cuda_cudart;
    TRITON_CUPTI_PATH = cudaPackages.cuda_cupti;
  };

  pythonRemoveDeps = [
    # Circular dependency, cf. https://github.com/triton-lang/triton/issues/1374
    "torch"

    # CLI tools without dist-info
    "cmake"
    "lit"
  ];

  # CMake is run by setup.py instead
  dontUseCmakeConfigure = true;

  nativeCheckInputs = [ cmake ];
  preCheck = ''
    # build/temp* refers to build_ext.build_temp (looked up in the build logs)
    (cd ./build/temp* ; ctest)
  '';

  pythonImportsCheck = [
    "triton"
    "triton.language"
  ];

  passthru = {
    gpuCheck = stdenv.mkDerivation {
      pname = "triton-pytest";
      inherit (triton) version src;

      requiredSystemFeatures = [ "cuda" ];

      nativeBuildInputs = [
        (python.withPackages (ps: [
          ps.scipy
          ps.torchWithCuda
          ps.triton-cuda
        ]))
      ];

      dontBuild = true;
      nativeCheckInputs = [
        pytestCheckHook
        writableTmpDirAsHomeHook
      ];

      doCheck = true;

      preCheck = ''
        cd python/test/unit
      '';
      checkPhase = "pytestCheckPhase";

      installPhase = "touch $out";
    };

    tests = {
      # Ultimately, torch is our test suite:
      inherit torchWithRocm;

      # Test that _get_path_to_hip_runtime_dylib works when ROCm is available at runtime
      rocm-libamdhip64-path =
        runCommand "triton-rocm-libamdhip64-path-test"
          {
            buildInputs = [
              triton
              python
              rocmPackages.clr
            ];
          }
          ''
            python -c "
            import os
            import triton
            path = triton.backends.amd.driver._get_path_to_hip_runtime_dylib()
            print(f'libamdhip64 path: {path}')
            assert os.path.exists(path)
            " && touch $out
          '';

      # Test as `nix run -f "<nixpkgs>" python3Packages.triton.tests.axpy-cuda`
      # or, using `programs.nix-required-mounts`, as `nix build -f "<nixpkgs>" python3Packages.triton.tests.axpy-cuda.gpuCheck`
      axpy-cuda =
        cudaPackages.writeGpuTestPython
          {
            libraries = ps: [
              ps.triton
              ps.torch-no-triton
            ];
          }
          ''
            # Adopted from Philippe Tillet https://triton-lang.org/main/getting-started/tutorials/01-vector-add.html

            import triton
            import triton.language as tl
            import torch
            import os

            @triton.jit
            def axpy_kernel(n, a: tl.constexpr, x_ptr, y_ptr, out, BLOCK_SIZE: tl.constexpr):
              pid = tl.program_id(axis=0)
              block_start = pid * BLOCK_SIZE
              offsets = block_start + tl.arange(0, BLOCK_SIZE)
              mask = offsets < n
              x = tl.load(x_ptr + offsets, mask=mask)
              y = tl.load(y_ptr + offsets, mask=mask)
              output = a * x + y
              tl.store(out + offsets, output, mask=mask)

            def axpy(a, x, y):
              output = torch.empty_like(x)
              assert x.is_cuda and y.is_cuda and output.is_cuda
              n_elements = output.numel()

              def grid(meta):
                return (triton.cdiv(n_elements, meta['BLOCK_SIZE']), )

              axpy_kernel[grid](n_elements, a, x, y, output, BLOCK_SIZE=1024)
              return output

            if __name__ == "__main__":
              if os.environ.get("HOME", None) == "/homeless-shelter":
                os.environ["HOME"] = os.environ.get("TMPDIR", "/tmp")
              if "CC" not in os.environ:
                os.environ["CC"] = "${lib.getExe' cudaPackages.backendStdenv.cc "cc"}"
              torch.manual_seed(0)
              size = 12345
              x = torch.rand(size, device='cuda')
              y = torch.rand(size, device='cuda')
              output_torch = 3.14 * x + y
              output_triton = axpy(3.14, x, y)
              assert output_torch.sub(output_triton).abs().max().item() < 1e-6
              print("Triton axpy: OK")
          '';
    };
  };

  meta = {
    description = "Language and compiler for writing highly efficient custom Deep-Learning primitives";
    homepage = "https://github.com/triton-lang/triton";
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      SomeoneSerge
      derdennisop
    ];
  };
}
