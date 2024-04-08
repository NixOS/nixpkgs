{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
, certifi
, charset-normalizer
, courlan
, htmldate
, justext
, lxml
, urllib3
, setuptools
}:

buildPythonPackage rec {
  pname = "trafilatura";
  version = "1.8.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-a4eN/b1cXftV0Pgwfyt9wVrDRYBU90hh/5ihcvXjhyA=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    certifi
    charset-normalizer
    courlan
    htmldate
    justext
    lxml
    urllib3
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # Disable tests that require an internet connection
    "test_download"
    "test_fetch"
    "test_redirection"
    "test_meta_redirections"
    "test_crawl_page"
    "test_whole"
    "test_probing"
    "test_cli_pipeline"
  ];

  # patch out gui cli because it is not supported in this packaging
  # nixify path to the trafilatura binary in the test suite
  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail '"trafilatura_gui=trafilatura.gui:main",' ""
    substituteInPlace tests/cli_tests.py \
      --replace-fail "trafilatura_bin = 'trafilatura'" "trafilatura_bin = '$out/bin/trafilatura'"
  '';

  pythonImportsCheck = [
    "trafilatura"
  ];

  meta = with lib; {
    description = "Python package and command-line tool designed to gather text on the Web";
    homepage = "https://trafilatura.readthedocs.io";
    changelog = "https://github.com/adbar/trafilatura/blob/v${version}/HISTORY.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ jokatzke ];
    mainProgram = "trafilatura";
  };
}
