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
  version = "3.2.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "12d8686454c721de88d8ca5adf07e1f419ef6dbcecedf65e8950d4a329daf3a0";
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
