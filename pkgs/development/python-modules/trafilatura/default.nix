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
  version = "1.9.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5oM9KauKE+2FOTfXyR5oaLxi774QIUrCsQZDbdI9FBI=";
  };

  # Patch out gui cli because it is not supported in this packaging and
  # nixify path to the trafilatura binary in the test suite
  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail '"trafilatura_gui=trafilatura.gui:main",' ""
    substituteInPlace tests/cli_tests.py \
      --replace-fail "trafilatura_bin = 'trafilatura'" "trafilatura_bin = '$out/bin/trafilatura'"
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
    "test_fetch"
    "test_meta_redirections"
    "test_probing"
    "test_queue"
    "test_redirection"
    "test_whole"
  ];

  pythonImportsCheck = [ "trafilatura" ];

  meta = with lib; {
    description = "Python package and command-line tool designed to gather text on the Web";
    homepage = "https://trafilatura.readthedocs.io";
    changelog = "https://github.com/adbar/trafilatura/blob/v${version}/HISTORY.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ jokatzke ];
    mainProgram = "trafilatura";
  };
}
