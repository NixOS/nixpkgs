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
  version = "3.1.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "d64c9f6712918a3d90ec5d71b44b8bab1083e3609e4844ad2be80eb633e097ed";
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
