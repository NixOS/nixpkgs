{ buildPythonPackage, lib, fetchPypi, isPy27
, odfpy
, openpyxl
, pandas
, pytest
, pytestcov
, pyyaml
, unicodecsv
, xlrd
, xlwt
}:

buildPythonPackage rec {
  pname = "tablib";
  version = "1.0.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ddvcgycv5m7q4rn5bch9qnhxjgn7192z537b1wzpmwd5s074cgz";
  };

  propagatedBuildInputs = [ xlwt openpyxl pyyaml xlrd odfpy ];
  checkInputs = [ pytest pytestcov unicodecsv pandas ];

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
