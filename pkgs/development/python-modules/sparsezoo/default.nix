{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  click,
  geocoder,
  numpy,
  onnx,
  pyyaml,
  requests,
  tqdm,
  pandas,
  protobuf,
  py-machineid,
  pydantic,

  # checks
  matplotlib,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "sparsezoo";
  version = "1.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "neuralmagic";
    repo = "sparsezoo";
    rev = "refs/tags/v${version}";
    hash = "sha256-c4F95eVvj673eFO/rbmv4LY3pGmqo+arbsYqElznwdA=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [ "onnx" ];

  dependencies = [
    click
    geocoder
    numpy
    onnx
    pyyaml
    requests
    tqdm
    pandas
    protobuf
    py-machineid
    pydantic
  ];

  pythonImportsCheck = [ "sparsezoo" ];

  nativeCheckInputs = [
    matplotlib
    pytestCheckHook
  ];

  disabledTests = [
    # Require network access
    "test_analysis"
    "test_custom_default"
    "test_draw_operation_chart"
    "test_draw_parameter_chart"
    "test_draw_parameter_operation_combined_chart"
    "test_draw_sparsity_by_layer_chart"
    "test_extract_node_id"
    "test_fail_default_on_empty"
    "test_folder_structure"
    "test_from_model_analysis"
    "test_generate_outputs"
    "test_get_layer_and_op_counts"
    "test_get_node_bias"
    "test_get_node_bias_name"
    "test_get_node_four_block_sparsity"
    "test_get_node_num_four_block_zeros_and_size"
    "test_get_node_num_zeros_and_size"
    "test_get_node_sparsity"
    "test_get_node_weight_and_shape"
    "test_get_node_weight_name"
    "test_get_ops_dict"
    "test_get_zero_point"
    "test_graphql_api_response"
    "test_is_four_block_sparse_layer"
    "test_is_parameterized_prunable_layer"
    "test_is_quantized_layer"
    "test_is_sparse_layer"
    "test_latency_extractor"
    "test_load_files_from_stub"
    "test_model_from_stub"
    "test_model_gz_extraction_from_local_files"
    "test_model_gz_extraction_from_stub"
    "test_recipe_getters"
    "test_search_models"
    "test_setup_model_from_objects"
    "test_setup_model_from_paths"
    "test_validate"
  ];

  disabledTestPaths = [
    # Require network access
    "tests/sparsezoo/analyze/test_model_analysis_creation.py"
    "tests/sparsezoo/deployment_package/utils/test_utils.py"
  ];

  meta = {
    description = "Neural network model repository for highly sparse and sparse-quantized models with matching sparsification recipes";
    homepage = "https://github.com/neuralmagic/sparsezoo";
    changelog = "https://github.com/neuralmagic/sparsezoo/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
