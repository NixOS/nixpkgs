{ lib
, buildPythonPackage
, fetchFromGitHub
# propagated build inputs
, chardet
, filetype
, lxml
, msg-parser
, nltk
, openpyxl
, pandas
, pdf2image
, pdfminer-six
, pillow
, pypandoc
, python-docx
, python-pptx
, python-magic
, markdown
, requests
, tabulate
, xlrd
# optional-dependencies
, langdetect
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
  optional-dependencies = {
    huggingflace = [
      langdetect
      sacremoses
      sentencepiece
      torch
      transformers
    ];
    local-inference = [ unstructured-inference ];
    s3 = [ s3fs fsspec ];
    azure = [ adlfs fsspec ];
    discord = [ ]; # discord-py
    github = [ pygithub ];
    gitlab = [ python-gitlab ];
    reddit = [ praw ];
    slack = [ slack-sdk ];
    wikipedia = [ wikipedia ];
    google-drive = [ google-api-python-client ];
    gcs = []; # gcsfs fsspec
    elasticsearch = [ elasticsearch8 jq ];
    dropbox = []; # dropboxdrivefs fsspec
    confluence = [ atlassian-python-api ];
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
    lxml
    msg-parser
    nltk
    openpyxl
    pandas
    pdf2image
    pdfminer-six
    pillow
    pypandoc
    python-docx
    python-pptx
    python-magic
    markdown
    requests
    tabulate
    xlrd
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
