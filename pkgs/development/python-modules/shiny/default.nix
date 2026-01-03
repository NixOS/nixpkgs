{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
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
  platformdirs,
  prompt-toolkit,
  python-multipart,
  questionary,
  shinychat,
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
  version = "1.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "posit-dev";
    repo = "py-shiny";
    tag = "v${version}";
    hash = "sha256-zRKfSY0rE+jzwYUcrRTIFW3OVmavhMDbAQEpry46zCI=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    asgiref
    click
    htmltools
    linkify-it-py
    markdown-it-py
    mdit-py-plugins
    narwhals
    orjson
    packaging
    platformdirs
    prompt-toolkit
    python-multipart
    questionary
    setuptools
    shinychat
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
  ]
  ++ lib.concatAttrValues optional-dependencies;

  pytestFlags = [
    # ERROR: 'fixture' is not a valid asyncio_default_fixture_loop_scope.
    # Valid scopes are: function, class, module, package, session.
    # https://github.com/pytest-dev/pytest-asyncio/issues/924
    "-o asyncio_mode=auto"
    "-o asyncio_default_fixture_loop_scope=function"
  ];

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
    changelog = "https://github.com/posit-dev/py-shiny/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
