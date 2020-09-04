{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, cssselect2
, lxml
, pillow
, pytest
, reportlab
, tinycss2
}:

buildPythonPackage rec {
  pname = "svglib";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ff01593e8c07ea462d3742e1f4141bfa261cbd4400ceb25dfb8fec3508ad0e50";
  };

  disabled = !isPy3k;

  propagatedBuildInputs = [
    cssselect2
    lxml
    pillow
    reportlab
    tinycss2
  ];

  checkInputs = [
    pytest
  ];

  # Ignore tests that require network access (TestWikipediaFlags and TestW3CSVG), and tests that
  # require files missing in the 1.0.0 PyPI release (TestOtherFiles).
  checkPhase = ''
    py.test svglib tests -k 'not TestWikipediaFlags and not TestW3CSVG and not TestOtherFiles'
  '';

  meta = with lib; {
    homepage = "https://github.com/deeplook/svglib";
    description = "A pure-Python library for reading and converting SVG";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ trepetti ];
  };
}
