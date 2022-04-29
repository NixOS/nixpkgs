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
  version = "1.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c77a0702fafd367c0fdca08ca1b7e1ee10058bde3bae252f49a3836e51e54519";
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
