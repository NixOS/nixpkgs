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
  version = "1.4.1";

  disabled = pythonOlder "3.7";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-SMJHBsI7tCYhc7b6Seq7EK+hW4QS8UKDEgVJUXzPoxQ=";
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

  # Ignore tests that require network access (TestWikipediaFlags and TestW3CSVG), and tests that
  # require files missing in the 1.0.0 PyPI release (TestOtherFiles).
  pytestFlagsArray = [
    "-k 'not TestWikipediaFlags and not TestW3CSVG and not TestOtherFiles'"
  ];

  pythonImportsCheck = [ "svglib.svglib" ];

  meta = with lib; {
    homepage = "https://github.com/deeplook/svglib";
    description = "A pure-Python library for reading and converting SVG";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ trepetti ];
  };
}
