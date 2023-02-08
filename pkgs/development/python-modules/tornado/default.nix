{ lib
, python
, buildPythonPackage
, fetchPypi
, pycares
, pycurl
, twisted
}:

buildPythonPackage rec {
  pname = "tornado";
  version = "6.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-m2MEGb3oTsZmv9fqCkyyqKZRwtXMzb3RlyoMhZ38PBM=";
  };

  nativeCheckInputs = [
    pycares
    pycurl
    twisted
  ];

  pythonImportsCheck = [ "tornado" ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "A web framework and asynchronous networking library";
    homepage = "https://www.tornadoweb.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
