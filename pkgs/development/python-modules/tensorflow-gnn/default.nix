{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchzip,
  pythonOlder,
  makeWrapper,
  protobufc,
  setuptools,
  apache-beam,
  tensorflow,
  tf-keras,
  numpy,
  protobuf,
  pytestCheckHook,
  mock,
  pandas,
  scipy,
  absl-py,
  pyyaml,
  pyarrow,
  google-vizier,
  ml-collections,
  networkx,
  sortedcontainers,
}:

let
  tensorflowProtoSrc = fetchzip {
    url = "https://github.com/tensorflow/tensorflow/archive/refs/tags/v2.13.0.tar.gz";
    hash = "sha256-Gw19dlQaBK+l5P843hMGhcFuckx5/tblsn8IfiwkwRc=";
    stripRoot = false;
  };
in
buildPythonPackage rec {
  pname = "tensorflow-gnn";
  version = "1.0.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "tensorflow";
    repo = "gnn";
    rev = "v${version}";
    hash = "sha256-JIYU+Zf0xA/47ptjXjFwx1B9AV08I7M8KIAAthpW5YE=";
  };

  nativeBuildInputs = [
    makeWrapper
    protobufc
  ];

  build-system = [
    setuptools
  ];

  dependencies = [
    apache-beam
    tensorflow
    tf-keras # Required for TensorFlow 2.16+ with TF_USE_LEGACY_KERAS=1
    numpy
    protobuf
    pyarrow
    google-vizier
    ml-collections
    networkx
    absl-py
  ];

  postPatch = ''
    # Skip the Bazel invocation; we pre-generate protos ourselves.
    python <<'PY'
    from pathlib import Path

    path = Path("setup.py")
    text = path.read_text()
    text = text.replace(
        "  sub_commands = [\n      ('bazel_build', _build_cc_extensions)] + build.build.sub_commands\n",
        "  sub_commands = build.build.sub_commands\n",
    )
    text = text.replace("    'bazel_build': _BazelBuildCommand,\n", "")
    path.write_text(text)
    PY
  '';

  nativeCheckInputs = [
    pytestCheckHook
    mock
    pandas
    scipy
    pyyaml # Required by apache-beam during tests
    sortedcontainers # Required by utils_test
  ];

  # The upstream build expects TF_USE_LEGACY_KERAS=1 to be set before importing the
  # package. Export it at runtime for python environments and wrap any scripts.
  postInstall = ''
    if [ -d "$out/bin" ]; then
      for prog in "$out"/bin/*; do
        [ -f "$prog" ] || continue
        wrapProgram "$prog" \
          --set TF_USE_LEGACY_KERAS 1
      done
    fi
  '';

  postFixup = ''
    mkdir -p "$out"/nix-support
    cat > "$out"/nix-support/setup-hook <<'EOF'
    export TF_USE_LEGACY_KERAS=1
    EOF
  '';

  preBuild = ''
    runHook preGenerateProtos
    proto_includes=(--proto_path=. --proto_path=${tensorflowProtoSrc}/tensorflow-2.13.0)
    for proto in \
      tensorflow_gnn/experimental/sampler/proto/eval_dag.proto \
      tensorflow_gnn/proto/graph_schema.proto \
      tensorflow_gnn/proto/examples.proto \
      tensorflow_gnn/sampler/sampling_spec.proto \
      tensorflow_gnn/sampler/unsupported/subgraph.proto \
      tensorflow_gnn/tools/sampled_stats.proto
    do
      protoc "''${proto_includes[@]}" --python_out=. "$proto"
    done
    runHook postGenerateProtos
  '';

  # Override the import check to make sure the hook executes for the test suite.
  pythonImportsCheckPhase = ''
    export TF_USE_LEGACY_KERAS=1
    runHook preInstallCheck

    python -c "import tensorflow_gnn, tensorflow_gnn.graph, tensorflow_gnn.keras, tensorflow_gnn.models, tensorflow_gnn.sampler, tensorflow_gnn.experimental, tensorflow_gnn.proto, tensorflow_gnn.runner"

    runHook postInstallCheck
  '';

  doCheck = true;

  pytestFlagsArray = [
    "-v"
    "--tb=short"
    "."
  ];

  preCheck = ''
    export TF_USE_LEGACY_KERAS=1
    # Ensure absl.flags is considered parsed so absltest helpers work under pytest.
    cat > conftest.py <<'EOF'
    import sys
    from absl import flags

    if not flags.FLAGS.is_parsed():
        flags.FLAGS(sys.argv[:1])
    EOF
  '';

  disabledTestPaths = [
    "tensorflow_gnn/experimental/sampler/custom_ops_test.py" # Requires Bazel-built custom ops.
    "tensorflow_gnn/api_def/api_symbols_test.py" # Namespace package import assumptions.
    "tensorflow_gnn/models/**/hparams_vizier_test.py" # Requires Vizier service stack + JAX.
    "tensorflow_gnn/experimental/datasets/pyg_adapter_test.py" # Requires torch_geometric.
    "tensorflow_gnn/experimental/sampler/beam/unigraph_utils_test.py" # apache-beam pickling issues.
    "tensorflow_gnn/experimental/sampler/beam/*_test.py"
    "tensorflow_gnn/experimental/sampler/subgraph_pipeline_test.py"
    "tensorflow_gnn/sampler/unsupported/sampling_lib_test.py"
    "tensorflow_gnn/models/contrastive_losses/distribute_test.py"
    "tensorflow_gnn/runner/distribute_test.py"
    "tensorflow_gnn/runner/utils/attribution_test.py"
    "tensorflow_gnn/graph/preprocessing_common_test.py"
    "tensorflow_gnn/tools/print_training_data_test.py"
    "tensorflow_gnn/tools/sampled_stats_test.py"
    "tensorflow_gnn/runner/orchestration_test.py"
    "tensorflow_gnn/experimental/sampler/beam/edge_samplers_test.py" # Relies on TF I/O pickling support not available in sandbox.
    "tensorflow_gnn/experimental/sampler/beam/executor_lib_test.py" # Fails serializing tf.function signatures under pytest.
    "tensorflow_gnn/tools/generate_training_data_test.py" # Needs example schema artifacts not shipped in wheel.
    "tensorflow_gnn/models/hgt/layers_test.py::HgtTest::test_hgtconv_saving_NoneInitializerRestoredKeras"
    "tensorflow_gnn/models/hgt/layers_test.py::HgtTest::test_hgtconv_saving_ObjInitializerRestoredKeras"
    "tensorflow_gnn/models/hgt/layers_test.py::HgtTest::test_hgtconv_saving_StrInitializerRestoredKeras"
    "tensorflow_gnn/models/multi_head_attention/layers_test.py::MultiHeadAttentionMPNNTFLiteTest::testBasicAllOps"
    "tensorflow_gnn/models/multi_head_attention/layers_test.py::MultiHeadAttentionMPNNTFLiteTest::testBasicSimplest"
    "tensorflow_gnn/models/multi_head_attention/layers_test.py::MultiHeadAttentionMPNNTFLiteTest::testBasicTransformedKeys"
    "tensorflow_gnn/models/vanilla_mpnn/layers_test.py::VanillaMPNNTFLiteTest::testBasicWithLayerNorm"
    "tensorflow_gnn/models/vanilla_mpnn/layers_test.py::VanillaMPNNTFLiteTest::testBasicWithoutLayerNorm"
    "tensorflow_gnn/runner/tasks/link_prediction_test.py::LinkPredictionTest::test_predict_on_hadamard_product_link_prediction"
    "tensorflow_gnn/runner/utils/model_export_test.py::ModelExportTests::test_simple_graph_piece"
  ];

  meta = {
    description = "Library to build Graph Neural Networks on the TensorFlow platform";
    homepage = "https://github.com/tensorflow/gnn";
    changelog = "https://github.com/tensorflow/gnn/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ siraben ];
  };
}
