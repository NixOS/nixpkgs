{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  certifi,
  charset-normalizer,
  courlan,
  htmldate,
  justext,
  lxml,
  urllib3,

  # tests
  addBinToPathHook,
  pytestCheckHook,
  versionCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "trafilatura";
  version = "2.3.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "adbar";
    repo = "trafilatura";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VcS0x7lU7bHIyJJm+tQVa8Eypyu5cvXjZ+i3tG/N7z0=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [
    "charset_normalizer"
    "lxml"
    "urllib3"
  ];
  dependencies = [
    certifi
    charset-normalizer
    courlan
    htmldate
    justext
    lxml
    urllib3
  ];

  nativeCheckInputs = [
    addBinToPathHook # tests need to execute the trafilatura binary
    pytestCheckHook
    versionCheckHook
  ];

  disabledTests = [
    # Disable tests that require an internet connection
    "test_cli_pipeline"
    "test_crawl_page"
    "test_download"
    "test_feeds_helpers"
    "test_fetch"
    "test_input_type"
    "test_is_live_page"
    "test_meta_redirections"
    "test_probing"
    "test_queue"
    "test_redirection"
    "test_whole"
  ];

  pythonImportsCheck = [ "trafilatura" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Python package and command-line tool designed to gather text on the Web";
    homepage = "https://trafilatura.readthedocs.io";
    changelog = "https://github.com/adbar/trafilatura/blob/${finalAttrs.src.tag}/HISTORY.md";
    downloadPage = "https://github.com/adbar/trafilatura";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jokatzke ];
    mainProgram = "trafilatura";
  };
})
