{
  lib,
  stdenv,
  torch,
  apple-sdk_13,
  buildPythonPackage,
  darwinMinVersionHook,
  fetchFromGitHub,

  # nativeBuildInputs
  libpng,
  ninja,
  which,

  # buildInputs
  libjpeg_turbo,

  # dependencies
  numpy,
  pillow,
  scipy,

  # tests
  pytest,
  writableTmpDirAsHomeHook,
}:

let
  inherit (torch) cudaCapabilities cudaPackages cudaSupport;

  pname = "torchvision";
  version = "0.21.0";
in
buildPythonPackage {
  inherit pname version;

  stdenv = torch.stdenv;

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "vision";
    tag = "v${version}";
    hash = "sha256-eDWw1Lt/sUc2Xt6cqOM5xaOfmsm+NEL5lZO+cIJKMtU=";
  };

  nativeBuildInputs = [
    libpng
    ninja
    which
  ] ++ lib.optionals cudaSupport [ cudaPackages.cuda_nvcc ];

  buildInputs =
    [
      libjpeg_turbo
      libpng
      torch.cxxdev
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # This should match the SDK used by `torch` above
      apple-sdk_13

      # error: unknown type name 'MPSGraphCompilationDescriptor'; did you mean 'MPSGraphExecutionDescriptor'?
      # https://developer.apple.com/documentation/metalperformanceshadersgraph/mpsgraphcompilationdescriptor/
      (darwinMinVersionHook "12.0")
    ];

  dependencies = [
    numpy
    pillow
    torch
    scipy
  ];

  preConfigure =
    ''
      export TORCHVISION_INCLUDE="${libjpeg_turbo.dev}/include/"
      export TORCHVISION_LIBRARY="${libjpeg_turbo}/lib/"
    ''
    + lib.optionalString cudaSupport ''
      export TORCH_CUDA_ARCH_LIST="${lib.concatStringsSep ";" cudaCapabilities}"
      export FORCE_CUDA=1
    '';

  # tests download big datasets, models, require internet connection, etc.
  doCheck = false;

  pythonImportsCheck = [ "torchvision" ];

  nativeCheckInputs = [
    pytest
    writableTmpDirAsHomeHook
  ];

  checkPhase = ''
    py.test test --ignore=test/test_datasets_download.py
  '';

  meta = {
    description = "PyTorch vision library";
    homepage = "https://pytorch.org/";
    changelog = "https://github.com/pytorch/vision/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    platforms = with lib.platforms; linux ++ lib.optionals (!cudaSupport) darwin;
    maintainers = with lib.maintainers; [ ericsagnes ];
  };
}
