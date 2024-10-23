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
}:

buildPythonPackage rec {
  pname = "torch-geometric";
  version = "2.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyg-team";
    repo = "pytorch_geometric";
    rev = "refs/tags/${version}";
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
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  disabledTests =
    [
      # TODO: try to re-enable when triton will have been updated to 3.0
      # torch._dynamo.exc.BackendCompilerFailed: backend='inductor' raised:
      # LoweringException: ImportError: cannot import name 'triton_key' from 'triton.compiler.compiler'
      "test_compile_hetero_conv_graph_breaks"
      "test_compile_multi_aggr_sage_conv"

      # RuntimeError: addmm: computation on CPU is not implemented for SparseCsr + SparseCsr @ SparseCsr without MKL.
      # PyTorch built with MKL has better support for addmm with sparse CPU tensors.
      "test_asap"
      "test_graph_unet"

      # AttributeError: type object 'Any' has no attribute '_name'
      "test_type_repr"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # This test uses `torch.jit` which might not be working on darwin:
      # RuntimeError: required keyword attribute 'value' has the wrong type
      "test_traceable_my_conv_with_self_loops"
    ];

  meta = {
    description = "Graph Neural Network Library for PyTorch";
    homepage = "https://github.com/pyg-team/pytorch_geometric";
    changelog = "https://github.com/pyg-team/pytorch_geometric/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
