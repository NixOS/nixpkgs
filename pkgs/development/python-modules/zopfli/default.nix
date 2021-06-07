{ lib, buildPythonPackage, fetchPypi, pytest }:

buildPythonPackage rec {
  pname = "zopfli";
  version = "0.1.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8b977dc07e3797907ab59e08096583bcd0b7e6c739849fbbeec09263f6356623";
    extension = "zip";
  };

  # doesn't work with pytestCheckHook
  checkInputs = [ pytest ];

  meta = with lib; {
    description = "cPython bindings for zopfli";
    homepage = "https://github.com/obp/py-zopfli";
    license = licenses.asl20;
    maintainers = [ maintainers.sternenseemann ];
  };
}
