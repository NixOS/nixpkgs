{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

  # build-system
  setuptools,

  # dependencies
  numpy,
  safetensors,
  torch,
  typing-extensions,

  # tests
  expecttest,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "torch-checkpointing";
  version = "0.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "meta-pytorch";
    repo = "torch_checkpointing";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gIvPI2s4l7th1RQocCku7NVf+3dledsc64Snbb8QL1E=";
  };

  patches = [
    # Fall back to buffered I/O on platforms without os.O_DIRECT (darwin)
    # https://github.com/meta-pytorch/torch_checkpointing/pull/10
    (fetchpatch {
      name = "fallback-without-o-direct.patch";
      url = "https://github.com/meta-pytorch/torch_checkpointing/commit/0b1cb0aa79a8358e00be1c10fd18572f5c20bd6b.patch";
      hash = "sha256-KAVWo8D6cIVJhi51rmJ1fh4G5/7voNa9EWemblz21+M=";
    })
  ];

  # The version was not bumped in pyproject.toml for the v0.1.1 tag
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail \
        'version = "0.1.0"' \
        'version = "${finalAttrs.version}"'
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    numpy
    safetensors
    torch
    typing-extensions
  ];

  pythonImportsCheck = [ "torch_checkpointing" ];

  nativeCheckInputs = [
    expecttest
    pytestCheckHook
  ];

  disabledTests = [
    # AssertionError: Expected to see a memory spike of 256 MiB but only saw 160.91015625 MiB
    "test_serving_a_request_releases_its_shared_memory"

    # RuntimeError: Unexpected response from worker process: Traceback (most recent call last):
    # TypeError: timedout_subprocess_init_fn() takes 0 positional arguments but 2 were given
    "test_subprocess_initialization_timeout"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
    # aarch64-linux fails cpuinfo test, because /sys/devices/system/cpu/ does not exist in the sandbox:
    # RuntimeError: Failed to initialize cpuinfo!
    "test_consolidate_hf_safetensors_rejects_dtype_mismatch_against_metadata"
    "test_write_read_multiple_dtypes"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # These tests simulate O_DIRECT refusals, but O_DIRECT is never attempted on darwin
    "test_direct_io_fallback_resumes_from_where_the_failed_read_started"
    "test_direct_io_refusal_is_remembered_by_the_storage"
    "test_direct_io_stream_falls_back_to_buffered_reads_on_einval"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "High-performance asynchronous checkpointing for PyTorch";
    homepage = "https://github.com/meta-pytorch/torch_checkpointing";
    changelog = "https://github.com/meta-pytorch/torch_checkpointing/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
