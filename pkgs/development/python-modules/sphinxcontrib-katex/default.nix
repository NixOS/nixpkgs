{ lib, buildPythonPackage, fetchPypi, pythonOlder, sphinx }:

buildPythonPackage rec {
  pname = "sphinxcontrib-katex";
  version = "0.6.0";

  # pkgutil namespaces are broken in nixpkgs (because they can't scan multiple
  # directories). But python2 is EOL, so not supporting it should be ok.
  disabled = pythonOlder "3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1692q3f3z1rsd3nyxd8wrv0vscwcq2gqjbv79c8ws402y3m7y5ni";
  };

  propagatedBuildInputs = [ sphinx ];

  # There are no unit tests
  doCheck = false;
  pythonImportsCheck = [ "sphinxcontrib.katex" ];

  meta = with lib; {
    description = "Sphinx extension using KaTeX to render math in HTML";
    homepage = "https://github.com/hagenw/sphinxcontrib-katex";
    license = licenses.mit;
    maintainers = with maintainers; [ jluttine ];
  };
}
