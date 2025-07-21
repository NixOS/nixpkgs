{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  flit-core,

  # dependencies
  aiohttp,
  fsspec,
  jinja2,
  numpy,
  psutil,
  pyparsing,
  requests,
  torch,
  tqdm,

  # optional-dependencies
  matplotlib,
  networkx,
  pandas,
  protobuf,
  wandb,
  ipython,
  matplotlib-inline,
  pre-commit,
  torch-geometric,
  ase,
  # captum,
  graphviz,
  h5py,
  numba,
  opt-einsum,
  pgmpy,
  pynndescent,
  # pytorch-memlab,
  rdflib,
  rdkit,
  scikit-image,
  scikit-learn,
  scipy,
  statsmodels,
  sympy,
  tabulate,
  torchmetrics,
  trimesh,
  pytorch-lightning,
  yacs,
  huggingface-hub,
  onnx,
  onnxruntime,
  pytest,
  pytest-cov-stub,

  # tests
  pytestCheckHook,
  writableTmpDirAsHomeHook,
  pythonAtLeast,
}:

buildPythonPackage rec {
  pname = "torch-geometric";
  version = "2.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyg-team";
    repo = "pytorch_geometric";
    tag = version;
    hash = "sha256-Zw9YqPQw2N0ZKn5i5Kl4Cjk9JDTmvZmyO/VvIVr6fTU=";
  };

  build-system = [
    flit-core
  ];

  dependencies = [
    aiohttp
    fsspec
    jinja2
    numpy
    psutil
    pyparsing
    requests
    torch
    tqdm
  ];

  optional-dependencies = {
    benchmark = [
      matplotlib
      networkx
      pandas
      protobuf
      wandb
    ];
    dev = [
      ipython
      matplotlib-inline
      pre-commit
      torch-geometric
    ];
    full = [
      ase
      # captum
      graphviz
      h5py
      matplotlib
      networkx
      numba
      opt-einsum
      pandas
      pgmpy
      pynndescent
      # pytorch-memlab
      rdflib
      rdkit
      scikit-image
      scikit-learn
      scipy
      statsmodels
      sympy
      tabulate
      torch-geometric
      torchmetrics
      trimesh
    ];
    graphgym = [
      protobuf
      pytorch-lightning
      yacs
    ];
    modelhub = [
      huggingface-hub
    ];
    test = [
      onnx
      onnxruntime
      pytest
      pytest-cov-stub
    ];
  };

  pythonImportsCheck = [
    "torch_geometric"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  disabledTests =
    [
      # RuntimeError: addmm: computation on CPU is not implemented for SparseCsr + SparseCsr @ SparseCsr without MKL.
      # PyTorch built with MKL has better support for addmm with sparse CPU tensors.
      "test_asap"
      "test_graph_unet"

      # AttributeError: type object 'Any' has no attribute '_name'
      "test_type_repr"

      # AttributeError: module 'torch.fx._symbolic_trace' has no attribute 'List'
      "test_set_clear_mask"
      "test_sequential_to_hetero"
      "test_to_fixed_size"
      "test_to_hetero_basic"
      "test_to_hetero_with_gcn"
      "test_to_hetero_with_basic_model"
      "test_to_hetero_and_rgcn_equal_output"
      "test_graph_level_to_hetero"
      "test_hetero_transformer_self_loop_error"
      "test_to_hetero_validate"
      "test_to_hetero_on_static_graphs"
      "test_to_hetero_with_bases"
      "test_to_hetero_with_bases_and_rgcn_equal_output"
      "test_to_hetero_with_bases_validate"
      "test_to_hetero_with_bases_on_static_graphs"
      "test_to_hetero_with_bases_save"

      # Failed: DID NOT WARN.
      "test_to_hetero_validate"
      "test_to_hetero_with_bases_validate"

      # Failed: DID NOT RAISE
      "test_scatter_backward"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # This test uses `torch.jit` which might not be working on darwin:
      # RuntimeError: required keyword attribute 'value' has the wrong type
      "test_traceable_my_conv_with_self_loops"
    ]
    ++ lib.optionals (pythonAtLeast "3.13") [
      # RuntimeError: Dynamo is not supported on Python 3.13+
      "test_compile"

      # RuntimeError: Python 3.13+ not yet supported for torch.compile
      "test_compile_graph_breaks"
      "test_compile_multi_aggr_sage_conv"
      "test_compile_hetero_conv_graph_breaks"

      # AttributeError: module 'typing' has no attribute 'io'. Did you mean: 'IO'?
      "test_packaging"

      # RuntimeError: Boolean value of Tensor with more than one value is ambiguous
      "test_feature_store"
    ];

  meta = {
    description = "Graph Neural Network Library for PyTorch";
    homepage = "https://github.com/pyg-team/pytorch_geometric";
    changelog = "https://github.com/pyg-team/pytorch_geometric/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
