{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, cssselect2
, lxml
, pillow
, pytestCheckHook
, reportlab
, tinycss2
}:

buildPythonPackage rec {
  pname = "svglib";
  version = "1.5.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Oudl06lAnuYMD7TSTC3raoBheqknBU9bzX/JjwaV5Yc=";
  };

  propagatedBuildInputs = [
    cssselect2
    lxml
    pillow
    reportlab
    tinycss2
  ];

  checkInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # Ignore tests that require network access (TestWikipediaFlags and TestW3CSVG), and tests that
    # require files missing in the 1.0.0 PyPI release (TestOtherFiles).
    "TestWikipediaFlags"
    "TestW3CSVG"
    "TestOtherFiles"
  ];

  pythonImportsCheck = [
    "svglib.svglib"
  ];

  meta = with lib; {
    description = "A pure-Python library for reading and converting SVG";
    homepage = "https://github.com/deeplook/svglib";
    changelog = "https://github.com/deeplook/svglib/blob/v${version}/CHANGELOG.rst";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ trepetti ];
  };
}
