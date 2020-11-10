{ lib, buildPythonPackage, fetchPypi, pytest }:

buildPythonPackage rec {
  pname = "zopfli";
  version = "0.1.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0smaxh7iihjr9mwxw1ifc9vnlh3ra8l060dd1gbvp1963k0r68pd";
    extension = "zip";
  };

  checkInputs = [ pytest ];

  meta = with lib; {
    description = "cPython bindings for zopfli";
    homepage = "https://github.com/obp/py-zopfli";
    license = licenses.asl20;
    maintainers = [ maintainers.sternenseemann ];
  };
}
