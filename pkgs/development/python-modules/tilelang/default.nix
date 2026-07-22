{
  lib,
  tilelang,

  cudaSupport ? torch.cudaSupport,

  buildPythonPackage,
  cudaPackages,
  fetchFromGitHub,
  python,
  pythonOlder,
  stdenv,

  # nativeBuildInputs
  autoPatchelfHook,
  writableTmpDirAsHomeHook,

  # build-system
  cmake,
  cython,
  ninja,
  scikit-build-core,

  # dependencies
  apache-tvm-ffi,
  cloudpickle,
  ml-dtypes,
  numpy,
  psutil,
  torch,
  torch-c-dlpack-ext,
  tqdm,
  typing-extensions,
  z3-solver,

  # optional-dependencies,
  matplotlib,

  # nativeCheckInputs
  einops,
  flash-linear-attention,
  pytestCheckHook,
}:
buildPythonPackage.override { inherit (torch) stdenv; } (finalAttrs: {
  pname = "tilelang";
  version = "0.1.11";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tile-ai";
    repo = "tilelang";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-C/c99/26/dBnQJYGrZ+NXl1Rqk3bjM2kpkgP/hWkTGE=";
  };

  postPatch =
    # remove binary only packages from build-system.requires (pythonRelaxDeps
    # doesn't work)
    ''
      substituteInPlace pyproject.toml \
        --replace-fail '"z3-solver' '# "z3-solver' \
        --replace-fail '"patchelf' '# "patchelf'
    ''
    # don't call git
    + ''
      sed -i '/def get_git_commit_id()/a\\    return None' version_provider.py
    ''
    # fix permissions for install_name_tool -id
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      substituteInPlace cmake/pypi-z3/FindZ3.cmake \
        --replace-fail COPYONLY 'FILE_PERMISSIONS
          OWNER_READ OWNER_WRITE OWNER_EXECUTE
          GROUP_READ GROUP_WRITE GROUP_EXECUTE
          WORLD_READ WORLD_WRITE WORLD_EXECUTE
          COPYONLY'
    '';

  nativeBuildInputs = [
    writableTmpDirAsHomeHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
  ]
  ++ lib.optionals cudaSupport [
    cudaPackages.cuda_nvcc
  ];

  build-system = [
    cmake
    cython
    ninja
    scikit-build-core
  ];

  env = {
    NO_GIT_VERSION = true;
    USE_CUDA = cudaSupport;
  };

  dontUseCmakeConfigure = true;

  cmakeFlags = [
    (lib.cmakeFeature "Z3_INCLUDE_DIR" "${z3-solver.dev}/include")
  ];

  buildInputs = lib.optionals cudaSupport [
    cudaPackages.cuda_cudart
    cudaPackages.cuda_nvrtc # nvrtc.h
  ];

  dependencies = [
    finalAttrs.passthru.apache-tvm-ffi
    cloudpickle
    ml-dtypes
    numpy
    psutil
    torch
    tqdm
    typing-extensions
    z3-solver
  ]
  ++ z3-solver.requiredPythonModules
  ++ lib.optionals (pythonOlder "3.14") [
    torch-c-dlpack-ext
  ];

  optional-dependencies = {
    vis = [
      matplotlib
    ];
  };

  preFixup =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      # libtvm_ffi.so
      addAutoPatchelfSearchPath "${finalAttrs.passthru.apache-tvm-ffi}/${python.sitePackages}/tvm_ffi/lib"
      # libz3.so.4.16
      addAutoPatchelfSearchPath "${z3-solver.lib}/lib"
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      # @rpath/libz3.dylib
      install_name_tool -add_rpath "${z3-solver.lib}/lib" \
        "$out/${python.sitePackages}/tilelang/lib/libtvm_compiler.dylib"
    '';

  pythonImportsCheck = [ "tilelang" ];

  # requires GPU
  doCheck = false;
  nativeCheckInputs = [
    einops
    flash-linear-attention
    pytestCheckHook
  ];
  disabledTestPaths = [
    "3rdparty"
    # ImportError: cannot import name 'AutoModelForVision2Seq' from 'transformers'
    "examples/bitnet-1.58b/vllm_workspace"
    # FileNotFoundError: [Errno 2] No such file or directory: './old/bin/python'
    "maint/scripts/test_perf_regression.py"
  ];

  passthru.gpuCheck = tilelang.overridePythonAttrs {
    requiredSystemFeatures = [ "cuda" ];
    doCheck = true;
  };

  passthru.apache-tvm-ffi = apache-tvm-ffi.overrideAttrs (previousAttrs: {
    version = "0.1.10";
    src = previousAttrs.src.override {
      tag = null;
      rev = "3c35034fd1026011736e19a4e0e1ed0f22058c42";
      hash = "sha256-dqAO6RLLGIRzPk7dNQsQCck+ziyONddhK/t4+S28cn8=";
    };
    # fix eval
    meta.changelog = "";
  });

  meta = {
    description = "Tile level programming language to generate high performance code";
    homepage = "https://tilelang.com/";
    downloadPage = "https://github.com/tile-ai/tilelang/releases";
    changelog = "https://github.com/tile-ai/tilelang/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      mit
      asl20 # 3rdparty/tvm
      bsd3 # 3rdparty/cutlass
    ];
    maintainers = with lib.maintainers; [ prince213 ];
  };
})
