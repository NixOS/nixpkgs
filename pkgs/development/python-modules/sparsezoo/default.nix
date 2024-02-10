{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonRelaxDepsHook
, setuptools
, wheel
, geocoder
, click
, numpy
, onnx
, pyyaml
, requests
, tqdm
, pandas
, protobuf
, py-machineid
, pydantic_1
, matplotlib
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "sparsezoo";
  version = "1.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "neuralmagic";
    repo = "sparsezoo";
    rev = "refs/tags/v${version}";
    hash = "sha256-Qu4ndF28YO41v0ix0vrbYiWsxCbmUjWXnwTTcvk+V6I=";
  };

  pythonRelaxDeps = [
    "onnx"
  ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
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
    pydantic_1
  ];

  pythonImportsCheck = [ "sparsezoo" ];

  nativeCheckInputs = [
    matplotlib
    pytestCheckHook
  ];

  disabledTests = [
    "test_extract_node_id"
    "test_get_layer_and_op_counts"
    "test_get_node_bias"
    "test_get_node_bias_name"
    "test_get_node_weight_name"
    "test_get_node_four_block_sparsity"
    "test_get_node_num_zeros_and_size"
    "test_get_node_sparsity"
    "test_get_node_weight_and_shape"
    "test_get_node_num_four_block_zeros_and_size"
    "test_get_ops_dict"
    "test_get_zero_point"
    "test_is_four_block_sparse_layer"
    "test_generate_outputs"
    "test_validate"
    "test_generate_outputs"
    "test_folder_structure"
    "test_draw_parameter_operation_combined_chart"
    "test_draw_operation_chart"
    "test_draw_sparsity_by_layer_chart"
    "test_analysis"
    "test_search_models"
    "test_recipe_getters"
    "test_custom_default"
    "test_fail_default_on_empty"
    "test_draw_parameter_chart"
    "test_latency_extractor"
    "test_graphql_api_response"
    "test_model_from_stub"
    "test_load_files_from_stub"
    "test_setup_model_from_paths"
    "test_setup_model_from_objects"
    "test_model_gz_extraction_from_stub"
    "test_model_gz_extraction_from_local_files"
    "test_model_deployment_directory"
    "test_is_parameterized_prunable_layer"
    "test_is_quantized_layer"
    "test_is_sparse_layer"
  ];

  disabledTestPaths = [
    "tests/sparsezoo/analyze/test_model_analysis_creation.py"
    "tests/sparsezoo/deployment_package/utils/test_utils.py"
  ];

  meta = with lib; {
    description = "Neural network model repository for highly sparse and sparse-quantized models with matching sparsification recipes";
    homepage = "https://github.com/neuralmagic/sparsezoo";
    license = licenses.asl20;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
