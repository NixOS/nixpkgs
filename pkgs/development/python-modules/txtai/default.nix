{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  pythonRelaxDepsHook,
  # propagated build input
  faiss,
  torch,
  transformers,
  huggingface-hub,
  numpy,
  pyyaml,
  regex,
  # optional-dependencies
  aiohttp,
  fastapi,
  uvicorn,
  # TODO add apache-libcloud
  # , apache-libcloud
  rich,
  duckdb,
  pillow,
  networkx,
  python-louvain,
  onnx,
  onnxruntime,
  soundfile,
  scipy,
  ttstokenizer,
  beautifulsoup4,
  nltk,
  pandas,
  tika,
  imagehash,
  timm,
  fasttext,
  sentencepiece,
  accelerate,
  onnxmltools,
  annoy,
  hnswlib,
  # TODO add pymagnitude-lite
  #, pymagnitude-lite
  scikit-learn,
  sentence-transformers,
  croniter,
  openpyxl,
  requests,
  xmltodict,
  # native check inputs
  unittestCheckHook,

  pythonAtLeast,
}:
let
  version = "7.2.0";
  api = [
    aiohttp
    fastapi
    uvicorn
  ];
  # cloud = [ apache-libcloud ];
  console = [ rich ];

  database = [
    duckdb
    pillow
  ];

  graph = [
    networkx
    python-louvain
  ];

  model = [
    onnx
    onnxruntime
  ];

  pipeline-audio = [
    onnx
    onnxruntime
    soundfile
    scipy
    ttstokenizer
  ];
  pipeline-data = [
    beautifulsoup4
    nltk
    pandas
    tika
  ];
  pipeline-image = [
    imagehash
    pillow
    timm
  ];
  pipeline-text = [
    fasttext
    sentencepiece
  ];
  pipeline-train = [
    accelerate
    onnx
    onnxmltools
    onnxruntime
  ];
  pipeline = pipeline-audio ++ pipeline-data ++ pipeline-image ++ pipeline-text ++ pipeline-train;

  similarity = [
    annoy
    fasttext
    hnswlib
    # pymagnitude-lite
    scikit-learn
    sentence-transformers
  ];
  workflow = [
    # apache-libcloud
    croniter
    openpyxl
    pandas
    pillow
    requests
    xmltodict
  ];
  all = api ++ console ++ database ++ graph ++ model ++ pipeline ++ similarity ++ workflow;

  optional-dependencies = {
    inherit
      api
      console
      database
      graph
      model
      pipeline-audio
      pipeline-image
      pipeline-text
      pipeline-train
      pipeline
      similarity
      workflow
      all
      ;
  };
in
buildPythonPackage {
  pname = "txtai";
  inherit version;
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "neuml";
    repo = "txtai";
    rev = "refs/tags/v${version}";
    hash = "sha256-2d31wzUz0/FcrejDIog2EI4BXgjd7XXpN4tRXpLk5DI=";
  };

  nativeBuildInputs = [ pythonRelaxDepsHook ];

  pythonRemoveDeps = [
    # We call it faiss, not faiss-cpu.
    "faiss-cpu"
  ];

  propagatedBuildInputs = [
    faiss
    torch
    transformers
    huggingface-hub
    numpy
    pyyaml
    regex
  ];

  passthru.optional-dependencies = optional-dependencies;

  pythonImportsCheck = [ "txtai" ];

  # some tests hang forever
  doCheck = false;

  preCheck = ''
    export TRANSFORMERS_CACHE=$(mktemp -d)
  '';

  nativeCheckInputs = [
    unittestCheckHook
  ] ++ optional-dependencies.api ++ optional-dependencies.similarity;

  unittestFlagsArray = [
    "-s"
    "test/python"
    "-v"
  ];

  meta = {
    description = "Semantic search and workflows powered by language models";
    changelog = "https://github.com/neuml/txtai/releases/tag/v${version}";
    homepage = "https://github.com/neuml/txtai";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ happysalada ];
    # This should be addressed in a newer version, but we first need to wait for python311Packages.faiss to be updated
    broken = pythonAtLeast "3.12";
  };
}
