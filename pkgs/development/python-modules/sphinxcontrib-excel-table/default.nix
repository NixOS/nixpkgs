{ lib
, buildPythonPackage
, fetchPypi
, docutils
, jinja2
, openpyxl
, sphinx
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-excel-table";
  version = "1.0.8";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7Utqi4MbWdYhqB5pa8isHsqleI93OYX5XjGPOaxf6eA=";
  };

  propagatedBuildInputs = [
    docutils
    jinja2
    openpyxl
    sphinx
  ];

  pythonImportsCheck = [ "sphinxcontrib.excel_table" ];

  # No tests present upstream
  doCheck = false;

  meta = with lib; {
    description = "Sphinx excel-table extension";
    homepage = "https://github.com/hackerain/sphinxcontrib-excel-table";
    maintainers = with maintainers; [ raboof ];
    license = licenses.asl20;
  };
}
