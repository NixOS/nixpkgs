{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "tree-sitter";
  version = "0.20.0";

  src = fetchPypi {
    pname = "tree_sitter";
    inherit version;
    sha256 = "sha256-GUD2S+HoycPA40oiWPHkwyQgdTTVse78WrKWCp2Y9mg=";
  };

  meta = with lib;{
    homepage = "https://github.com/tree-sitter/py-tree-sitter";
    description = "Python bindings to the Tree-sitter parsing library";
    license = licenses.mit;
    maintainers = [ maintainers.McSinyx ];
  };
}
