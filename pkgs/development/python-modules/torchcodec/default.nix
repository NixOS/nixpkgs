{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # nativeBuildInputs
  pkg-config,

  # buildInputs
  ffmpeg,

  # build-system
  cmake,
  setuptools,
  torch,

  # tests
  pytestCheckHook,
  torchvision,

  cudaSupport ? torch.cudaSupport,
  cudaPackages,
  rocmSupport ? torch.rocmSupport,
}:

buildPythonPackage.override { inherit (torch) stdenv; } (finalAttrs: {
  pname = "torchcodec";
  version = "0.11.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "meta-pytorch";
    repo = "torchcodec";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aYQp9vEVQJgF1n/KsfnDvLQf5nD0/gsG+RAgVlhk7t8=";
  };

  postPatch = ''
    substituteInPlace \
      test/utils.py \
      test/test_encoders.py \
      --replace-fail \
        '"ffprobe"' \
        '"${lib.getExe' ffmpeg "ffprobe"}"'

    substituteInPlace test/test_encoders.py \
      --replace-fail \
        '"ffmpeg"' \
        '"${lib.getExe ffmpeg}"'

    substituteInPlace test/test_transform_ops.py \
      --replace-fail \
        'ffmpeg_cli = "ffmpeg"' \
        'ffmpeg_cli = "${lib.getExe ffmpeg}"'
  '';

  nativeBuildInputs = [
    pkg-config
  ]
  ++ lib.optionals cudaSupport [
    cudaPackages.cuda_nvcc
  ];

  buildInputs = [
    ffmpeg
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
    ]
  );

  build-system = [
    cmake
    setuptools
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
  }
  // lib.optionalAttrs rocmSupport {
    ROCM_PATH = torch.rocmtoolkit_joined;
    ROCM_SOURCE_DIR = torch.rocmtoolkit_joined;
    PYTORCH_ROCM_ARCH = torch.gpuTargetString;
    CMAKE_CXX_FLAGS = "-I${torch.rocmtoolkit_joined}/include";
  };

  pythonImportsCheck = [ "torchcodec" ];

  nativeCheckInputs = [
    pytestCheckHook
    torchvision
  ];

  disabledTests =
    lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
      # AssertionError: index 0
      "test_get_frames_played_at"

      # AssertionError: Tensor-likes are not equal!
      "test_against_cli"
      "test_against_ref"
      "test_color_conversion_library"
      "test_color_conversion_library_with_dimension_order"
      "test_compile"
      "test_compile_seek_and_next"
      "test_create_decoder"
      "test_crop_transform"
      "test_custom_frame_mappings_json_and_bytes"
      "test_file_like_decoding"
      "test_get_frame_at"
      "test_get_frame_at_av1"
      "test_get_frame_at_index"
      "test_get_frame_at_pts"
      "test_get_frame_played_at"
      "test_get_frame_played_at_h265"
      "test_get_frame_with_info_at_index"
      "test_get_frames_at"
      "test_get_frames_at_indices"
      "test_get_frames_at_indices_negative_indices"
      "test_get_frames_by_pts_in_range"
      "test_get_frames_in_range"
      "test_get_frames_in_range_slice_indices_syntax"
      "test_get_frames_with_missing_num_frames_metadata"
      "test_getitem_int"
      "test_getitem_numpy_int"
      "test_getitem_slice"
      "test_iteration"
      "test_seek_and_next"
      "test_seek_mode_custom_frame_mappings"
      "test_seek_to_negative_pts"
      "test_throws_exception_at_eof"
    ]
    ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) [
      # RuntimeError: Invalid AVIO context holder
      "test_1d_samples"
      "test_against_cli"
      "test_against_to_file"
      "test_against_to_file"
      "test_contiguit"
      "test_crf_valid_value"
      "test_encode_to_tensor_long_outpu"
      "test_num_channels"
      "test_round_trip"
      "test_video_encoder_against_ffmpeg_cli"
      "test_video_encoder_round_trip"

      # RuntimeError: Requested next frame while there are no more frames left to decode
      "test_next"
      "test_throws_exception_at_eof"
      "test_throws_exception_if_seek_too_far"
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
