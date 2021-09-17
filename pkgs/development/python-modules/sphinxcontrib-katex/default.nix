{ lib, buildPythonPackage, fetchPypi, pythonOlder, sphinx }:

buildPythonPackage rec {
  pname = "sphinxcontrib-katex";
  version = "0.8.6";

  # pkgutil namespaces are broken in nixpkgs (because they can't scan multiple
  # directories). But python2 is EOL, so not supporting it should be ok.
  disabled = pythonOlder "3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c3dcdb2984626a0e6c1b11bc2580c7bbc6ab3711879b23bbf26c028a0f4fd4f2";
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
