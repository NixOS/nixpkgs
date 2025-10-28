{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # core networking and async dependencies
  anyio,
  backoff,
  certifi,
  httpcore,
  httpx,
  h11,
  nest-asyncio,
  requests,
  requests-toolbelt,
  sniffio,
  urllib3,

  # core parsing and processing
  beautifulsoup4,
  chardet,
  charset-normalizer,
  emoji,
  filetype,
  html5lib,
  idna,
  joblib,
  # jsonpath-python,
  nltk,
  olefile,
  orderly-set,
  python-dateutil,
  python-iso639,
  python-magic,
  python-oxmsg,
  rapidfuzz,
  regex,
  soupsieve,
  webencodings,

  # core data handling
  dataclasses-json,
  deepdiff,
  marshmallow,
  mypy-extensions,
  packaging,
  typing-extensions,
  typing-inspect,

  # core system utilities
  cffi,
  cryptography,
  psutil,
  pycparser,
  six,
  tqdm,
  wrapt,

  # document format support
  markdown,
  pdfminer-six,
  pdfplumber,
  # pi-heif,
  pikepdf,
  pypandoc,
  pypdf,
  python-docx,
  unstructured-client,
  # unstructured-pytesseract,
  # optional dependencies
  # csv
  pytz,
  tzdata,
  # markdown
  importlib-metadata,
  zipp,
  # pdf
  opencv-python,
  paddlepaddle,
  pdf2image,
  # unstructured-paddleocr,
  # pptx
  lxml,
  pillow,
  python-pptx,
  xlsxwriter,
  # xslx
  et-xmlfile,
  networkx,
  numpy,
  openpyxl,
  pandas,
  xlrd,
  # huggingface
  langdetect,
  sacremoses,
  sentencepiece,
  torch,
  transformers,
  # local-inference
  unstructured-inference,
  # test dependencies
  pytestCheckHook,
  black,
  coverage,
  click,
  freezegun,
  # , label-studio-sdk
  mypy,
  pytest-cov-stub,
  pytest-mock,
  vcrpy,
  grpcio,
}:
let
  version = "0.18.15";
in
buildPythonPackage rec {
  pname = "unstructured";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Unstructured-IO";
    repo = "unstructured";
    tag = version;
    hash = "sha256-rzspozQQ+WrS3cKAGe9O7clAIDo4P/6PdZzCXIRdNn8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    # Base dependencies
    anyio
    backoff
    beautifulsoup4
    certifi
    cffi
    chardet
    charset-normalizer
    click
    cryptography
    dataclasses-json
    deepdiff
    emoji
    filetype
    h11
    html5lib
    httpcore
    httpx
    idna
    joblib
    # jsonpath-python
    langdetect
    lxml
    marshmallow
    mypy-extensions
    nest-asyncio
    nltk
    numpy
    olefile
    orderly-set
    packaging
    psutil
    pycparser
    pypdf
    python-dateutil
    python-iso639
    python-magic
    python-oxmsg
    rapidfuzz
    regex
    requests
    requests-toolbelt
    six
    sniffio
    soupsieve
    tqdm
    typing-extensions
    typing-inspect
    unstructured-client
    urllib3
    webencodings
    wrapt
  ];

  optional-dependencies = rec {
    all-docs = csv ++ docx ++ epub ++ pdf ++ req-markdown ++ odt ++ org ++ pptx ++ xlsx;
    csv = [
      numpy
      pandas
      python-dateutil
      pytz
      tzdata
    ];
    docx = [
      lxml
      python-docx
      typing-extensions
    ];
    epub = [ pypandoc ];
    req-markdown = [
      importlib-metadata
      markdown
      zipp
    ];
    odt = [
      lxml
      pypandoc
      python-docx
      typing-extensions
    ];
    org = [
      pypandoc
    ];
    paddleocr = [
      opencv-python
      # paddlepaddle # 3.12 not supported for now
      pdf2image
      # unstructured-paddleocr
    ];
    pdf = [
      pdf2image
      pdfminer-six
      pdfplumber
      # pi-heif
      pikepdf
      pypdf
      unstructured-inference
      # unstructured-pytesseract
    ];
    pptx = [
      lxml
      pillow
      python-pptx
      xlsxwriter
    ];
    xlsx = [
      et-xmlfile
      networkx
      numpy
      openpyxl
      pandas
      xlrd
    ];
    huggingface = [
      langdetect
      sacremoses
      sentencepiece
      torch
      transformers
    ];
  };

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
    pytest-cov-stub
    pytest-mock
    vcrpy
    grpcio
  ];

  meta = with lib; {
    description = "Open source libraries and APIs to build custom preprocessing pipelines for labeling, training, or production machine learning pipelines";
    mainProgram = "unstructured-ingest";
    homepage = "https://github.com/Unstructured-IO/unstructured";
    changelog = "https://github.com/Unstructured-IO/unstructured/blob/${src.tag}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ happysalada ];
  };
}
