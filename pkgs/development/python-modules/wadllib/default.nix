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
  version = "1.3.6";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rNmtaiwQB9NMogjh2mNBu8oYBMDmhQ+VTbBL3XZmxfw=";
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
