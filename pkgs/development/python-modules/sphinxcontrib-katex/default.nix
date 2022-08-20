{ lib, buildPythonPackage, fetchPypi, pythonOlder, sphinx }:

buildPythonPackage rec {
  pname = "sphinxcontrib-katex";
  version = "0.9.0";

  # pkgutil namespaces are broken in nixpkgs (because they can't scan multiple
  # directories). But python2 is EOL, so not supporting it should be ok.
  disabled = pythonOlder "3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-HFs1+9tWl1D5VWY14dPCk+Ewv+ubedhd9DcCSrPQZnQ=";
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
