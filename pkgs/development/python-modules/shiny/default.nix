{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  appdirs,
  asgiref,
  click,
  htmltools,
  libsass,
  linkify-it-py,
  markdown-it-py,
  mdit-py-plugins,
  narwhals,
  orjson,
  packaging,
  prompt-toolkit,
  python-multipart,
  questionary,
  starlette,
  typing-extensions,
  uvicorn,
  watchfiles,
  websockets,

  # tests
  anthropic,
  cacert,
  google-generativeai,
  langchain-core,
  ollama,
  openai,
  pandas,
  polars,
  pytest-asyncio,
  pytest-playwright,
  pytest-rerunfailures,
  pytest-timeout,
  pytest-xdist,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "shiny";
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "posit-dev";
    repo = "py-shiny";
    tag = "v${version}";
    hash = "sha256-YCPHjelGPYYo23Vzxy5+8Kn9fVlSZy1Qva7zp93+nzg=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    appdirs
    asgiref
    click
    htmltools
    linkify-it-py
    markdown-it-py
    mdit-py-plugins
    narwhals
    orjson
    packaging
    prompt-toolkit
    python-multipart
    questionary
    setuptools
    starlette
    typing-extensions
    uvicorn
    watchfiles
    websockets
  ];

  optional-dependencies = {
    theme = [
      libsass
      # FIXME package brand-yml
    ];
  };

  pythonImportsCheck = [ "shiny" ];

  nativeCheckInputs = [
    anthropic
    google-generativeai
    langchain-core
    ollama
    openai
    pandas
    polars
    pytest-asyncio
    pytest-playwright
    pytest-rerunfailures
    pytest-timeout
    pytest-xdist
    pytestCheckHook
  ] ++ lib.flatten (lib.attrValues optional-dependencies);

  env.SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

  disabledTests = [
    # Requires unpackaged brand-yml
    "test_theme_from_brand_base_case_compiles"
    # ValueError: A tokenizer is required to impose `token_limits` on messages
    "test_chat_message_trimming"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Build fast, beautiful web applications in Python";
    homepage = "https://shiny.posit.co/py";
    changelog = "https://github.com/posit-dev/py-shiny/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
