{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest
, pytestcov
, unicodecsv
, pandas
, xlwt
, openpyxl
, pyyaml
, xlrd
, odfpy
, markuppy
}:

buildPythonPackage rec {
  pname = "tablib";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = pname;
    rev = "v${version}";
    sha256 = "1i50nbr7wxk1m6nh8bx0icci2hr9xc9sqi2ypj3ykkvl66sii2z7";
  };

  checkInputs = [
    pytest
    pytestcov
    unicodecsv
    pandas
  ];

  propagatedBuildInputs = [
    xlwt
    openpyxl
    pyyaml
    xlrd
    odfpy
    markuppy
  ];

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "Tablib: format-agnostic tabular dataset library";
    homepage = http://python-tablib.org;
    license = licenses.mit;
  };
}
