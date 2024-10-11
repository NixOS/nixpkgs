{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
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
  pgvector,
  sqlite-vec,
  python-multipart,
  # native check inputs
  pytestCheckHook,
  # check inputs
  httpx,
  msgpack,
  sqlalchemy,
}:
let
  version = "7.4.0";
  api = [
    aiohttp
    fastapi
    pillow
    python-multipart
    uvicorn
  ];
  ann = [
    annoy
    hnswlib
    pgvector
    sqlalchemy
    sqlite-vec
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
  all = api ++ ann ++ console ++ database ++ graph ++ model ++ pipeline ++ similarity ++ workflow;

  optional-dependencies = {
    inherit
      ann
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
  pyproject = true;


  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "neuml";
    repo = "txtai";
    rev = "refs/tags/v${version}";
    hash = "sha256-DQB12mFUMsKJ8cACowI1Vc7k2n1npdTOQknRmHd5EIM=";
  };

  buildTools = [ setuptools ];

  pythonRemoveDeps = [
    # We call it faiss, not faiss-cpu.
    "faiss-cpu"
  ];

  dependencies = [
    faiss
    torch
    transformers
    huggingface-hub
    numpy
    pyyaml
    regex
  ];

  optional-dependencies = optional-dependencies;

  # The Python imports check runs huggingface-hub which needs a writable directory.
  #  `pythonImportsCheck` runs in the installPhase (before checkPhase).
  preInstall = ''
    export HF_HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [ "txtai" ];

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ optional-dependencies.ann ++ optional-dependencies.api ++ optional-dependencies.similarity;

  checkInputs = [
    httpx
    msgpack
    python-multipart
    sqlalchemy
  ];

  # The deselected paths depend on the huggingface hub and should be run as a passthru test
  # disabledTestPaths won't work as the problem is with the classes containing the tests
  # (in other words, it fails on __init__)
  pytestFlagsArray = [
    "test/python/test*.py"
    "--deselect=test/python/testcloud.py"
    "--deselect=test/python/testconsole.py"
    "--deselect=test/python/testembeddings.py"
    "--deselect=test/python/testgraph.py"
    "--deselect=test/python/testapi/testembeddings.py"
    "--deselect=test/python/testapi/testpipelines.py"
    "--deselect=test/python/testapi/testworkflow.py"
    "--deselect=test/python/testdatabase/testclient.py"
    "--deselect=test/python/testdatabase/testduckdb.py"
    "--deselect=test/python/testdatabase/testencoder.py"
    "--deselect=test/python/testworkflow.py"
  ];

  disabledTests = [
    # Hardcoded paths
    "testInvalidTar"
    "testInvalidZip"
    # Downloads from Huggingface
    "testPipeline"
    # Not finding sqlite-vec despite being supplied
    "testSQLite"
    "testSQLiteCustom"
  ];

  meta = {
    description = "Semantic search and workflows powered by language models";
    changelog = "https://github.com/neuml/txtai/releases/tag/v${version}";
    homepage = "https://github.com/neuml/txtai";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ happysalada ];
  };
}
