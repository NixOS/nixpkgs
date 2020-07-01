{ lib, buildPythonPackage, fetchPypi, pythonOlder, sphinx }:

buildPythonPackage rec {
  pname = "sphinxcontrib-katex";
  version = "0.6.1";

  # pkgutil namespaces are broken in nixpkgs (because they can't scan multiple
  # directories). But python2 is EOL, so not supporting it should be ok.
  disabled = pythonOlder "3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "88320b2780f350d67f84a5424973ce24aee65701e8e163a7f5856c5df3353188";
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
