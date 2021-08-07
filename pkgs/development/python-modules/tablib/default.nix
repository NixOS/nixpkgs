{ buildPythonPackage, lib, fetchPypi, isPy27
, odfpy
, openpyxl
, pandas
, setuptools-scm
, pytest
, pytest-cov
, pyyaml
, unicodecsv
, xlrd
, xlwt
}:

buildPythonPackage rec {
  pname = "tablib";
  version = "3.0.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "f83cac08454f225a34a305daa20e2110d5e6335135d505f93bc66583a5f9c10d";
  };

  nativeBuildInputs = [ setuptools-scm ];
  propagatedBuildInputs = [ xlwt openpyxl pyyaml xlrd odfpy ];
  checkInputs = [ pytest pytest-cov unicodecsv pandas ];

  # test_tablib needs MarkupPy, which isn't packaged yet
  checkPhase = ''
    pytest --ignore tests/test_tablib.py
  '';

  meta = with lib; {
    description = "Format-agnostic tabular dataset library";
    homepage = "https://python-tablib.org";
    license = licenses.mit;
  };
}
