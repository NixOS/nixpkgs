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
  # agent
  mcpadapt,
  smolagents,
  # ann
  annoy,
  hnswlib,
  pgvector,
  sqlalchemy,
  sqlite-vec-c,
  # api
  aiohttp,
  fastapi,
  fastapi-mcp,
  httpx,
  pillow,
  python-multipart,
  uvicorn,
  # cloud
  # apache-libcloud, (unpackaged)
  fasteners,
  # console
  rich,
  # database
  duckdb,
  # graph
  # grand-cypher (unpackaged)
  # grand-graph (unpackaged)
  networkx,
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
  gliner,
  sentencepiece,
  staticvectors,
  # pipeline-train
  accelerate,
  bitsandbytes,
  onnxmltools,
  peft,
  skl2onnx,
  # vectors
  fasttext,
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
  msgpack,
  pytestCheckHook,
}:
let
  version = "9.1.0";
  agent = [
    mcpadapt
    smolagents
  ];
  ann = [
    annoy
    hnswlib
    pgvector
    sqlalchemy
    sqlite-vec-c
  ];
  api = [
    aiohttp
    fastapi
    fastapi-mcp
    httpx
    pillow
    python-multipart
    uvicorn
  ];
  cloud = [
    # apache-libcloud
    fasteners
  ];
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
    gliner
    sentencepiece
    staticvectors
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
    agent
    ++ api
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
      agent
      ann
      api
      cloud
      console
      database
      graph
      model
      pipeline-audio
      pipeline-data
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

  src = fetchFromGitHub {
    owner = "neuml";
    repo = "txtai";
    tag = "v${version}";
    hash = "sha256-5wr9fTfLVwGksD/+wbw4CktSznDi/xI/WfZBG3+BNYc=";
  };
in
buildPythonPackage {
  pname = "txtai";
  inherit version src;
  pyproject = true;

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
    timm
    sqlalchemy
  ]
  ++ optional-dependencies.agent
  ++ optional-dependencies.ann
  ++ optional-dependencies.api
  ++ optional-dependencies.similarity;

  pytestFlagsArray = [
    "test/python/*"
  ];

  disabledTests = [
    # Hardcoded paths
    "testInvalidTar"
    "testInvalidZip"
    # Downloads from Huggingface
    "TestAgent"
    "TestCloud"
    "TestConsole"
    "TestEmbeddings"
    "TestGraph"
    "TestWorkflow"
    "testPipeline"
    "testVectors"
    # Not finding sqlite-vec despite being supplied
    "testSQLite"
    "testSQLiteCustom"
  ];

  meta = {
    description = "Semantic search and workflows powered by language models";
    changelog = "https://github.com/neuml/txtai/releases/tag/${src.tag}";
    homepage = "https://github.com/neuml/txtai";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ happysalada ];
  };
}
