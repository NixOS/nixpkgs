{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  faiss,
  torch,
  transformers,
  huggingface-hub,
  numpy,
  pyyaml,
  regex,

  # optional-dependencies
  # ann
  annoy,
  hnswlib,
  pgvector,
  sqlalchemy,
  sqlite-vec,
  # api
  aiohttp,
  fastapi,
  pillow,
  python-multipart,
  uvicorn,
  # cloud
  # apache-libcloud, (unpackaged)
  # console
  rich,
  # database
  duckdb,
  # graph
  # grand-cypher (unpackaged)
  # grand-graph (unpackaged)
  networkx,
  python-louvain,
  # model
  onnx,
  onnxruntime,
  # pipeline-audio
  # model2vec,
  sounddevice,
  soundfile,
  scipy,
  ttstokenizer,
  webrtcvad,
  # pipeline-data
  beautifulsoup4,
  nltk,
  pandas,
  tika,
  # pipeline-image
  imagehash,
  timm,
  # pipeline-llm
  litellm,
  # llama-cpp-python, (unpackaged)
  # pipeline-text
  fasttext,
  sentencepiece,
  # pipeline-train
  accelerate,
  bitsandbytes,
  onnxmltools,
  peft,
  skl2onnx,
  # vectors
  # pymagnitude-lite, (unpackaged)
  scikit-learn,
  sentence-transformers,
  skops,
  # workflow
  # apache-libcloud (unpackaged)
  croniter,
  openpyxl,
  requests,
  xmltodict,

  # tests
  httpx,
  msgpack,
  pytestCheckHook,
}:
let
  version = "8.1.0";
  ann = [
    annoy
    hnswlib
    pgvector
    sqlalchemy
    sqlite-vec
  ];
  api = [
    aiohttp
    fastapi
    pillow
    python-multipart
    uvicorn
  ];
  # cloud = [ apache-libcloud ];
  console = [ rich ];
  database = [
    duckdb
    pillow
    sqlalchemy
  ];
  graph = [
    # grand-cypher
    # grand-graph
    networkx
    python-louvain
    sqlalchemy
  ];
  model = [
    onnx
    onnxruntime
  ];
  pipeline-audio = [
    onnx
    onnxruntime
    scipy
    sounddevice
    soundfile
    ttstokenizer
    webrtcvad
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
  pipeline-llm = [
    litellm
    # llama-cpp-python
  ];
  pipeline-text = [
    fasttext
    sentencepiece
  ];
  pipeline-train = [
    accelerate
    bitsandbytes
    onnx
    onnxmltools
    onnxruntime
    peft
    skl2onnx
  ];
  pipeline =
    pipeline-audio
    ++ pipeline-data
    ++ pipeline-image
    ++ pipeline-llm
    ++ pipeline-text
    ++ pipeline-train;
  scoring = [ sqlalchemy ];
  vectors = [
    fasttext
    litellm
    # llama-cpp-python
    # model2vec
    # pymagnitude-lite
    scikit-learn
    sentence-transformers
    skops
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
  similarity = ann ++ vectors;
  all =
    api
    ++ ann
    ++ console
    ++ database
    ++ graph
    ++ model
    ++ pipeline
    ++ scoring
    ++ similarity
    ++ workflow;

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
      pipeline-llm
      pipeline-text
      pipeline-train
      pipeline
      scoring
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

  src = fetchFromGitHub {
    owner = "neuml";
    repo = "txtai";
    tag = "v${version}";
    hash = "sha256-12EeYzZEHUS5HVxpKlTnV6mwnnOw1pQVG0f0ID/Ugik=";
  };

  build-system = [ setuptools ];

  pythonRemoveDeps = [
    # We call it faiss, not faiss-cpu.
    "faiss-cpu"
  ];

  dependencies = [
    faiss
    huggingface-hub
    msgpack
    numpy
    pyyaml
    regex
    torch
    transformers
  ];

  optional-dependencies = optional-dependencies;

  # The Python imports check runs huggingface-hub which needs a writable directory.
  #  `pythonImportsCheck` runs in the installPhase (before checkPhase).
  preInstall = ''
    export HF_HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [ "txtai" ];

  nativeCheckInputs = [
    httpx
    msgpack
    pytestCheckHook
    python-multipart
    sqlalchemy
  ] ++ optional-dependencies.ann ++ optional-dependencies.api ++ optional-dependencies.similarity;

  # The deselected paths depend on the huggingface hub and should be run as a passthru test
  # disabledTestPaths won't work as the problem is with the classes containing the tests
  # (in other words, it fails on __init__)
  pytestFlagsArray = [
    "test/python/test*.py"
    "--deselect=test/python/testagent.py"
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
