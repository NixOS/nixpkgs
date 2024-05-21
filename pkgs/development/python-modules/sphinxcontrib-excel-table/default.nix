{ lib
, buildPythonPackage
, fetchPypi
, sphinx
, openpyxl
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-excel-table";
  version = "1.0.8";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256:1q79byn3k3ribvwqafbpixwabjhymk46ns8ym0hxcn8vhf5nljzd";
  };

  propagatedBuildInputs = [ sphinx openpyxl ];

  pythonImportsCheck = [ "sphinxcontrib.excel_table" ];

  # No tests present upstream
  doCheck = false;

  pythonNamespaces = [ "sphinxcontrib" ];

  meta = with lib; {
    description = "Sphinx excel-table extension";
    homepage = "https://github.com/hackerain/sphinxcontrib-excel-table";
    maintainers = with maintainers; [ raboof ];
    license = licenses.asl20;
  };
}
