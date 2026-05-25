{
  lib,
  buildPythonPackage,
  fetchPypi,
  termcolor,
  colorama,
  setuptools,
}:

buildPythonPackage rec {
  pname = "veryprettytable";
  version = "0.8.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1k1rifz8x6qcicmx2is9vgxcj0qb2f5pvzrp7zhmvbmci3yack3f";
  };

  build-system = [ setuptools ];

  dependencies = [
    termcolor
    colorama
  ];

  meta = {
    description = "Simple Python library for easily displaying tabular data in a visually appealing ASCII table format";
    homepage = "https://github.com/smeggingsmegger/VeryPrettyTable";
    license = lib.licenses.free;
  };
}
