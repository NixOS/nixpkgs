{ lib, fetchPypi, buildPythonPackage, sphinx }:

buildPythonPackage rec {
  version = "0.3.0";
  pname = "sphinx-navtree";
  src = fetchPypi {
    inherit pname version;
    sha256 = "1nqcsbqwr8ihk1fv534i0naag1qw04f7ibcgl2j8csvkh8q90b4p";
  };

  propagatedBuildInputs = [ sphinx ];

  meta = {
    description = "Navigation tree customization for Sphinx";
    homepage = https://github.com/bintoro/sphinx-navtree;
    license = lib.licenses.mit;
  };
}
