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
}:

buildPythonPackage rec {
  pname = "trafilatura";
  version = "1.7.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-oWbmfwBaahLvGU9Ix8n6ThsONnVv3Stk4CRzw1aWLwQ=";
  };

  propagatedBuildInputs = [
    certifi
    charset-normalizer
    courlan
    htmldate
    justext
    lxml
    urllib3
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  # disable tests that require an internet connection
  disabledTests = [
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
    substituteInPlace setup.py --replace '"trafilatura_gui=trafilatura.gui:main",' ""
    substituteInPlace tests/cli_tests.py --replace "trafilatura_bin = 'trafilatura'" "trafilatura_bin = '$out/bin/trafilatura'"
  '';

  pythonImportsCheck = [ "trafilatura" ];

  meta = with lib; {
    description = "Python package and command-line tool designed to gather text on the Web";
    mainProgram = "trafilatura";
    homepage = "https://trafilatura.readthedocs.io";
    changelog = "https://github.com/adbar/trafilatura/blob/v${version}/HISTORY.md";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jokatzke ];
  };
}
