{
  lib,
  buildPythonPackage,
  certifi,
  charset-normalizer,
  courlan,
  fetchPypi,
  htmldate,
  justext,
  lxml,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  urllib3,
}:

buildPythonPackage rec {
  pname = "trafilatura";
  version = "1.12.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TJyxQ09+E+8LFstE7h1E6EUj7HJolAuVWcN05+/8mpY=";
  };

  # Patch out gui cli because it is not supported in this packaging and
  # nixify path to the trafilatura binary in the test suite
  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail '"trafilatura_gui=trafilatura.gui:main",' ""
    substituteInPlace tests/cli_tests.py \
      --replace-fail 'trafilatura_bin = "trafilatura"' \
                     'trafilatura_bin = "${placeholder "out"}/bin/trafilatura"'
  '';

  build-system = [ setuptools ];

  dependencies = [
    certifi
    charset-normalizer
    courlan
    htmldate
    justext
    lxml
    urllib3
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # Disable tests that require an internet connection
    "test_cli_pipeline"
    "test_crawl_page"
    "test_download"
    "test_feeds_helpers"
    "test_fetch"
    "test_is_live_page"
    "test_meta_redirections"
    "test_probing"
    "test_queue"
    "test_redirection"
    "test_whole"
  ];

  pythonImportsCheck = [ "trafilatura" ];

  meta = {
    description = "Python package and command-line tool designed to gather text on the Web";
    homepage = "https://trafilatura.readthedocs.io";
    changelog = "https://github.com/adbar/trafilatura/blob/v${version}/HISTORY.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jokatzke ];
    mainProgram = "trafilatura";
  };
}
