{ lib
, buildPythonPackage
, fetchFromGitHub
# propagated build inputs
, chardet
, filetype
, python-magic
, lxml
, nltk
, tabulate
, requests
, beautifulsoup4
, emoji
, dataclasses-json
, python-iso639
, langdetect
, numpy
, rapidfuzz
, backoff
, typing-extensions
, unstructured-client
, wrapt
# optional-dependencies
, pandas
, python-docx
, pypandoc
, markdown
, msg-parser
, onnx
, pdf2image
, pdfminer-six
, pikepdf
, pillow-heif
, pypdf
, python-pptx
, openpyxl
, xlrd
, networkx
, sacremoses
, sentencepiece
, torch
, transformers
, unstructured-inference
, s3fs
, fsspec
, adlfs
# , discord-py
, pygithub
, python-gitlab
, praw
, slack-sdk
, wikipedia
, google-api-python-client
# , gcsfs
, elasticsearch8
, jq
# , dropboxdrivefs
, atlassian-python-api
# test dependencies
, pytestCheckHook
, black
, coverage
, click
, freezegun
# , label-studio-sdk
, mypy
, pytest-cov
, pytest-mock
, vcrpy
, grpcio
}:
let
  version = "0.13.0";
  csv = [ pandas ];
  tsv = csv;
  doc = [ python-docx ];
  docx = doc;
  epub = [ pypandoc ];
  md = [ markdown ];
  msg = [ msg-parser ];
  odt = [ python-docx pypandoc ];
  # paddleocr = [ unstructured.paddleocr ];
  org = [ pypandoc ];
  rtf = org;
  rst = org;
  image = [
    onnx
    pdf2image
    pdfminer-six
    pikepdf
    pillow-heif
    pypdf
    unstructured-inference
    # unstructured.pytessseract
  ];
  pdf = image;
  pptx = [ python-pptx ];
  ppt = pptx;
  xlsx = [ openpyxl pandas xlrd networkx ];
  all-docs = [ csv docx epub image md msg odt org pdf pptx xlsx ];
  optional-dependencies = {
    inherit csv doc docx epub image md msg odt org pdf ppt pptx rtf rst tsv xlsx all-docs;
    # data ingest
    # airtable = []
    # astra = []
    azure = [ adlfs fsspec ];
    # azure-cognitive-search = []
    # biomed = []
    # box = []
    # chroma = []
    # clarifai = []
    confluence = [ atlassian-python-api ];
    # delta-table = []
    discord = [ ]; # discord-py
    dropbox = []; # dropboxdrivefs fsspec
    elasticsearch = [ elasticsearch8 jq ];
    gcs = []; # gcsfs fsspec
    github = [ pygithub ];
    gitlab = [ python-gitlab ];
    google-drive = [ google-api-python-client ];
    # hubspot = []
    # jira = []
    # mongodb = []
    # notion = []
    # onedrive = []
    # opensearch = []
    # outlook = []
    # pinecone = []
    # postgres = []
    # qdrant = []
    reddit = [ praw ];
    s3 = [ s3fs fsspec ];
    # sharepoint = []
    # salesforce = []
    # sftp = []
    slack = [ slack-sdk ];
    wikipedia = [ wikipedia ];
    # weaviate = []

    # all legacy requirements
    huggingface = [
      langdetect
      sacremoses
      sentencepiece
      torch
      transformers
    ];
    local-inference = all-docs;
  };
in
buildPythonPackage {
  pname = "unstructured";
  inherit version;
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Unstructured-IO";
    repo = "unstructured";
    rev = "refs/tags/${version}";
    hash = "sha256-zRQOFYAh4QpDNlSPi1h70eOmw/8aTa6yAKBSgTuIhME=";
  };

  propagatedBuildInputs = [
    chardet
    filetype
    python-magic
    lxml
    nltk
    tabulate
    requests
    beautifulsoup4
    emoji
    dataclasses-json
    python-iso639
    langdetect
    numpy
    rapidfuzz
    backoff
    typing-extensions
    unstructured-client
    wrapt
  ];

  pythonImportsCheck = [ "unstructured" ];

  # test try to download punkt from nltk
  # figure out how to make it available to enable the tests
  doCheck = false;

  nativeCheckInputs = [
    pytestCheckHook
    black
    coverage
    click
    freezegun
    mypy
    pytest-cov
    pytest-mock
    vcrpy
    grpcio
  ];

  passthru.optional-dependencies = optional-dependencies;

  meta = with lib; {
    description = "Open source libraries and APIs to build custom preprocessing pipelines for labeling, training, or production machine learning pipelines";
    mainProgram = "unstructured-ingest";
    homepage = "https://github.com/Unstructured-IO/unstructured";
    changelog = "https://github.com/Unstructured-IO/unstructured/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ happysalada ];
  };
}
