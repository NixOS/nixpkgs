{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  sphinx,
  openpyxl,
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-excel-table";
  version = "1.0.8";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256:1q79byn3k3ribvwqafbpixwabjhymk46ns8ym0hxcn8vhf5nljzd";
  };

  build-system = [ setuptools ];

  dependencies = [
    sphinx
    openpyxl
  ];

  pythonImportsCheck = [ "sphinxcontrib.excel_table" ];

  # No tests present upstream
  doCheck = false;

  pythonNamespaces = [ "sphinxcontrib" ];

  meta = {
    description = "Sphinx excel-table extension";
    homepage = "https://github.com/hackerain/sphinxcontrib-excel-table";
    maintainers = with lib.maintainers; [ raboof ];
    license = lib.licenses.asl20;
  };
}
