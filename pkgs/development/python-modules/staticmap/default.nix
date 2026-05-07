{
  lib,
  buildPythonPackage,
  fetchPypi,
  pillow,
  requests,
}:

buildPythonPackage rec {
  pname = "staticmap";
  version = "0.5.7";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-x6lrkCumEpLoGMILCBBhnWuBps21C8wauS1QrE2yCn8=";
  };

  propagatedBuildInputs = [
    requests
    pillow
  ];

  pythonImportsCheck = [ "staticmap" ];

  # Tests seem to be broken
  doCheck = false;

  meta = {
    description = "Small, python-based library for creating map images with lines and markers";
    homepage = "https://pypi.org/project/staticmap/";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ traxys ];
  };
}
