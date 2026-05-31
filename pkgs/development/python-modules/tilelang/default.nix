{
  lib,
  autoPatchelfHook,
  buildPythonPackage,
  cudaPackages,
  fetchFromGitHub,
  python,
  pythonOlder,
  writableTmpDirAsHomeHook,

  apache-tvm-ffi,
  cloudpickle,
  cmake,
  cython,
  matplotlib,
  ml-dtypes,
  ninja,
  numpy,
  psutil,
  scikit-build-core,
  torch,
  torch-c-dlpack-ext,
  tqdm,
  typing-extensions,
  z3-solver,
}:
buildPythonPackage (finalAttrs: {
  pname = "tilelang";
  version = "0.1.10";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tile-ai";
    repo = "tilelang";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-ZxdmKyq21wMxXNbae/jiayPjZu48he0sutGIc06++lI=";
  };

  patches = [
    ./build-system.patch
    ./version-provider.patch
  ];

  build-system = [
    cmake
    cython
    ninja
    scikit-build-core
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    cudaPackages.cuda_nvcc
  ];

  buildInputs = [
    cudaPackages.cuda_cudart
    cudaPackages.cuda_nvrtc # nvrtc.h
    z3-solver.lib
  ];

  dontUseCmakeConfigure = true;
  cmakeFlags = [
    (lib.cmakeFeature "Z3_INCLUDE_DIR" "${z3-solver.dev}/include")
  ];

  dependencies = [
    apache-tvm-ffi
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
  ++ (lib.optional (pythonOlder "3.14") torch-c-dlpack-ext);

  optional-dependencies = {
    vis = [
      matplotlib
    ];
  };

  # z3 does not provide a dist-info, so python-runtime-deps-check will fail
  pythonRemoveDeps = [ "z3-solver" ];

  extraAutoPatchelfLibs = [
    # libtvm_ffi.so
    "${apache-tvm-ffi}/${python.sitePackages}/tvm_ffi/lib"
  ];

  nativeInstallCheckInputs = [
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [
    "tilelang"
  ];

  # __main__.py: error: the following arguments are required: example_exe
  # doCheck = false;

  env.NO_VERSION_LABEL = true;

  meta = {
    description = "Tile level programming language to generate high performance code";
    homepage = "https://tilelang.com/";
    downloadPage = "https://github.com/tile-ai/tilelang/releases";
    changelog = "https://github.com/tile-ai/tilelang/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      mit
      asl20 # 3rdparty/tvm
    ];
    maintainers = with lib.maintainers; [ prince213 ];
  };
})
