{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  setuptools,
  setuptools-scm,

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

  anthropic,
  cacert,
  google-generativeai,
  langchain-core,
  ollama,
  openai,
  pytestCheckHook,
  pytest-asyncio,
  pytest-playwright,
  pytest-xdist,
  pytest-timeout,
  pytest-rerunfailures,
  pandas,
  polars,
}:

buildPythonPackage rec {
  pname = "shiny";
  version = "1.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "posit-dev";
    repo = "py-shiny";
    tag = "v${version}";
    hash = "sha256-8bo2RHuIP7X7EaOlHd+2m4XU287owchAwiqPnpjKFjI=";
  };

  patches = [
    (fetchpatch {
      name = "fix-narwhals-test.patch";
      url = "https://github.com/posit-dev/py-shiny/commit/184a9ebd81ff730439513f343576a68f8c1f6eb9.patch";
      hash = "sha256-DsGnuHQXODzGwpe8ZUHeXGzRFxxduwxCRk82RJaYZg0=";
    })
  ];

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
    pytestCheckHook
    pytest-asyncio
    pytest-playwright
    pytest-xdist
    pytest-timeout
    pytest-rerunfailures
    pandas
    polars
  ] ++ lib.flatten (lib.attrValues optional-dependencies);

  env.SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

  disabledTests = [
    # ValueError: A tokenizer is required to impose `token_limits` on messages
    "test_chat_message_trimming"
    # https://github.com/posit-dev/py-shiny/pull/1791
    "test_as_ollama_message"
  ];

  meta = {
    changelog = "https://github.com/posit-dev/py-shiny/blob/${src.tag}/CHANGELOG.md";
    description = "Build fast, beautiful web applications in Python";
    license = lib.licenses.mit;
    homepage = "https://shiny.posit.co/py";
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
