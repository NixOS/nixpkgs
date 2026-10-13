{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  symlinkJoin,

  # nativeBuildInputs
  pkg-config,

  # buildInputs
  ffmpeg-headless,
  libavif,
  libheif,
  libjpeg,
  libpng,
  libwebp,

  # build-system
  cmake,
  ninja,
  pybind11,
  scikit-build-core,
  torch,

  # tests
  pytestCheckHook,
  torchvision,

  cudaSupport ? torch.cudaSupport,
  rocmSupport ? torch.rocmSupport,
}:

let
  inherit (torch) cudaCapabilities cudaPackages;

  # Unlike the other image codecs, upstream's CMake has no `find_package` path for libavif: it
  # unconditionally FetchContent-downloads a prebuilt tarball from S3.
  # Point FetchContent at our own libavif instead, which it expects to find as `include/` and
  # `lib/libavif.so.16` under a single root.
  # https://github.com/meta-pytorch/torchcodec/blob/v0.17.0/src/torchcodec/_core/fetch_avif_from_s3.cmake
  libavif-root = symlinkJoin {
    name = "libavif-root";
    paths = [
      (lib.getDev libavif)
      (lib.getLib libavif)
    ];
  };
in
buildPythonPackage.override { inherit (torch) stdenv; } (finalAttrs: {
  pname = "torchcodec";
  version = "0.17.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "meta-pytorch";
    repo = "torchcodec";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IvxVtbH43RpJ4HZ8r/g6/+Ab5xBRk9uQUSIi1Af78O0=";
  };

  postPatch = ''
    substituteInPlace \
      test/utils.py \
      test/test_encoders.py \
      --replace-fail \
        '"ffprobe"' \
        '"${lib.getExe' ffmpeg-headless "ffprobe"}"'

    substituteInPlace test/test_encoders.py \
      --replace-fail \
        '"ffmpeg"' \
        '"${lib.getExe ffmpeg-headless}"'

    substituteInPlace test/test_transform_ops.py \
      --replace-fail \
        'ffmpeg_cli = "ffmpeg"' \
        'ffmpeg_cli = "${lib.getExe ffmpeg-headless}"'

    substituteInPlace test/test_decoders.py \
      --replace-fail \
        '"ffmpeg", "-' \
        '"${lib.getExe ffmpeg-headless}", "-'
  '';

  nativeBuildInputs = [
    pkg-config
  ]
  ++ lib.optionals cudaSupport [
    cudaPackages.cuda_nvcc
  ]
  ++ lib.optionals rocmSupport [
    torch.rocmPackages.clr
  ];

  buildInputs = [
    ffmpeg-headless
    libavif
    libheif
    libjpeg
    libpng
    libwebp
  ]
  ++ lib.optionals cudaSupport (
    with cudaPackages;
    [
      cuda_cudart
      cuda_nvrtc
      libcublas # cublas_v2.h
      libcusolver # cusolverDn.h
      libcusparse # cusparse.h
      libnpp # nppicc
      libnvjpeg # nvjpeg.h
    ]
  );

  build-system = [
    cmake
    ninja
    pybind11
    scikit-build-core
    torch
  ];
  dontUseCmakeConfigure = true;

  dependencies = [
    torch
  ];

  env = {
    # Upstream (Meta) is cautious with linking against GPL ffmpeg
    # We explicitly want to link against our packaged ffmpeg
    I_CONFIRM_THIS_IS_NOT_A_LICENSE_VIOLATION = true;

    ENABLE_CUDA = cudaSupport;

    CMAKE_ARGS = toString [
      (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_AVIF_S3" libavif-root.outPath)
    ];
  }
  // lib.optionalAttrs cudaSupport {
    TORCH_CUDA_ARCH_LIST = "${lib.concatStringsSep ";" cudaCapabilities}";
  }
  // lib.optionalAttrs rocmSupport {
    ROCM_PATH = torch.rocmtoolkit_joined;
    ROCM_SOURCE_DIR = torch.rocmtoolkit_joined;
    PYTORCH_ROCM_ARCH = torch.gpuTargetString;
    CMAKE_CXX_FLAGS = "-I${lib.getInclude torch.rocmtoolkit_joined}/include";
  };

  pythonImportsCheck = [ "torchcodec" ];

  nativeCheckInputs = [
    pytestCheckHook
    torchvision
  ];

  __darwinAllowLocalNetworking = true;

  disabledTestPaths = [
    # Shells out to `pip install` to set up a plugin package
    "test/plugin/test_plugins.py"
  ];

  disabledTests = [
    # AssertionError: Tensor-likes are not close!
    "test_audio_against_cli"
  ]
  ++ lib.optionals rocmSupport [
    # HSA runtime logs topology error in sandbox breaking test that asserts no output
    "test_python_logger"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
    # Fails in the sandbox:
    # Error in cpuinfo: failed to parse the list of possible processors in /sys/devices/system/cpu/possible
    "test_python_logger"
  ];

  meta = {
    description = "PyTorch media decoding and encoding";
    homepage = "https://github.com/meta-pytorch/torchcodec";
    changelog = "https://github.com/meta-pytorch/torchcodec/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      GaetanLepage
      caniko
    ];
  };
})
