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
  version = "6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "33c6e81d7bd55b468d2e793517c909b139960b6c790a60b7991b9b6b76fb9791";
  };

  checkInputs = [
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
