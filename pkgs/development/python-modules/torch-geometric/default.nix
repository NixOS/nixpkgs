{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, util-linux
, setuptools
, ase
, graphviz
, h5py
, huggingface-hub
, hydra-core
, jinja2
, matplotlib
, networkx
, numba
, numpy
, opt-einsum
, pandas
, pgmpy
, protobuf
, psutil
, pyparsing
, pytorch-lightning
, rdflib
, requests
, scikit-image
, scikit-learn
, scipy
, statsmodels
, sympy
, tabulate
, torch
, torch-cluster
, torch-sparse
, torchmetrics
, tqdm
, trimesh
, yacs
}:

buildPythonPackage rec {
  pname = "torch-geometric";
  version = "2.3.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pyg-team";
    repo = "pytorch_geometric";
    rev = "refs/tags/${version}";
    hash = "sha256-69I54tVnPLz0GSpvgFxhiUkvrUqutRxfBi1TULjfqgw=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    jinja2
    numpy
    psutil
    pyparsing
    requests
    scikit-learn
    scipy
    torch
    tqdm
  ];

  passthru.optional-dependencies = {
    graphgym = [
      hydra-core
      protobuf
      pytorch-lightning
      yacs
    ];
    modelhub = [
      huggingface-hub
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
      # pytorch-memlab
      rdflib
      scikit-image
      statsmodels
      sympy
      tabulate
      torchmetrics
      trimesh
    ] ++ passthru.optional-dependencies.graphgym
      ++ passthru.optional-dependencies.modelhub;
  };

  nativeCheckInputs = [
    pytestCheckHook
    torch-cluster
    torch-sparse
  ] ++ lib.optionals stdenv.isLinux [
    util-linux
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  disabledTests = [
    # raise urllib.error.URLError
    "test_appnp"
    "test_basic_gnn_inference"
    "test_basic_gnn_inference"
    "test_citeseer"
    "test_citeseer_with_full_split"
    "test_citeseer_with_random_split"
    "test_cleaned_enzymes"
    "test_enzymes"
    "test_enzymes_with_node_attr"
    "test_hetero_neighbor_loader_on_cora"
    "test_hgt_loader_on_cora"
    "test_homo_neighbor_loader_on_cora"
    "test_mutag"
    "test_mutag_with_node_attr"
    "test_neighbor_sampler_on_cora"
    "test_torch_profile"
  ];

  pythonImportsCheck = [ "torch_geometric" ];

  meta = with lib; {
    description = "Graph Neural Network Library for PyTorch";
    homepage = "https://github.com/pyg-team/pytorch_geometric";
    changelog = "https://github.com/pyg-team/pytorch_geometric/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
