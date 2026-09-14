{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

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
  version = "0.1.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "meta-pytorch";
    repo = "torch_checkpointing";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2D9iJVLPKUp5jAnqUHr/cdv0rb+mvWVr8AVkEM3qUjw=";
  };

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
    # RuntimeError: Unexpected response from worker process: Traceback (most recent call last):
    # TypeError: timedout_subprocess_init_fn() takes 0 positional arguments but 2 were given
    "test_subprocess_initialization_timeout"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
    # aarch64-linux fails cpuinfo test, because /sys/devices/system/cpu/ does not exist in the sandbox:
    # RuntimeError: Failed to initialize cpuinfo!
    "test_write_read_multiple_dtypes"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # AttributeError: module 'os' has no attribute 'O_DIRECT'. Did you mean: 'O_CREAT'?
    "test_async_sequential_saves"
    "test_atomic_stream_write_preserves_file_after_failure"
    "test_atomic_stream_write_replaces_file_after_success"
    "test_checkpoint_write_future_state_dict"
    "test_checkpoint_write_sync_state_dict"
    "test_consolidate_hf_safetensors_balances_default_mapping_across_ranks"
    "test_consolidate_hf_safetensors_buffers_noncontiguous_destination_slices"
    "test_consolidate_hf_safetensors_can_disable_tensor_metadata_validation"
    "test_consolidate_hf_safetensors_converts_nested_path_at_hf_boundary"
    "test_consolidate_hf_safetensors_defaults_single_fqn_to_one_file"
    "test_consolidate_hf_safetensors_exports_plain_item_from_metadata"
    "test_consolidate_hf_safetensors_exports_plain_only_item"
    "test_consolidate_hf_safetensors_ignores_and_logs_mapping_fqns_not_in_checkpoint"
    "test_consolidate_hf_safetensors_ignores_unused_rank_layout"
    "test_consolidate_hf_safetensors_reads_contiguous_slices_into_output_buffer"
    "test_consolidate_hf_safetensors_uses_rank_zero_for_single_output_file"
    "test_consolidate_hf_safetensors_uses_replicated_metadata_for_plain_tensor"
    "test_consolidate_hf_safetensors_uses_replicated_metadata_for_plain_tensor"
    "test_consolidate_hf_safetensors_writes_to_separate_output_dir"
    "test_load_basic"
    "test_load_before_save_prepares_metadata"
    "test_load_full_model_from_partial_checkpoint"
    "test_load_returns_none"
    "test_load_with_metadata_manager"
    "test_make_async_checkpoint_saver"
    "test_make_sync_checkpoint_saver"
    "test_make_sync_checkpoint_saver_with_config_first"
    "test_make_sync_checkpoint_saver_with_custom_config"
    "test_metadata_cache_invalidation_on_structure_change"
    "test_metadata_file_written"
    "test_metadata_sent_once_to_subprocess"
    "test_mixed_serialization_formats"
    "test_multiple_saves_reuse_cached_metadata"
    "test_nested_dict_partial_load"
    "test_partial_load"
    "test_save_and_load_basic"
    "test_shared_memory_tensor_ipc"
    "test_write_calls_callbacks"
    "test_write_read_model_state_dict"
    "test_write_read_multiple_dtypes"
    "test_write_read_roundtrip_flat_tensors"
    "test_write_read_roundtrip_list_of_tensors"
    "test_write_read_roundtrip_nested_partial_target_reports_missing"
    "test_write_read_roundtrip_nested_tensors_no_target_returns_flat"
    "test_write_read_roundtrip_nested_tensors_with_target_renests"
    "test_write_read_with_metadata"
    "test_write_with_global_file_layout"
    "test_write_with_layout_extra_keys"
    "test_write_with_simple_layout"
    "test_write_without_callbacks"
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
