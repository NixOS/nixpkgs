{ lib, buildPythonPackage, fetchPypi, pytest }:

buildPythonPackage rec {
  pname = "zopfli";
  version = "0.1.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "512892714f0e3dcc9a77222cb509ed519f41ce2b92467e47a4b406a23b48561a";
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
