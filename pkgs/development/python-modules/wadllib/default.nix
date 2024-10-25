{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPy3k,
  setuptools,
  lazr-uri,
}:

buildPythonPackage rec {
  pname = "wadllib";
  version = "1.3.9";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-wL4oM4myKP/ZPNru+44HDyLd98tcd+SMaMOWD98lmEQ=";
  };

  propagatedBuildInputs = [
    setuptools
    lazr-uri
  ];

  doCheck = isPy3k;

  meta = with lib; {
    description = "Navigate HTTP resources using WADL files as guides";
    homepage = "https://launchpad.net/wadllib";
    license = licenses.lgpl3;
    maintainers = [ ];
  };
}
