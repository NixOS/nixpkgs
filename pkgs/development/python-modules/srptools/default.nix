{ lib, buildPythonPackage, fetchPypi, six, pytest, pytest-runner }:

buildPythonPackage rec {
  pname = "srptools";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7fa4337256a1542e8f5bb4bed19e1d9aea98fe5ff9baf76693342a1dd6ac7c96";
  };

  propagatedBuildInputs = [ six ];

  checkInputs = [ pytest pytest-runner ];

  meta = with lib; {
    description = "Python-Tools to implement Secure Remote Password (SRP) authentication";
    homepage = "https://github.com/idlesign/srptools";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
