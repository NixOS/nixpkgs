{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "takethetime";
  version = "0.3.1";
  format = "setuptools";

  src = fetchPypi {
    pname = "TakeTheTime";
    inherit version;
    hash = "sha256-2+MEU6G1lqOPni4/qOGtxa8tv2RsoIN61cIFmhb+L/k=";
  };

  disabled = pythonOlder "3.6";

  # all tests are timing dependent
  doCheck = false;

  pythonImportsCheck = [ "takethetime" ];

<<<<<<< HEAD
  meta = {
    description = "Simple time taking library using context managers";
    homepage = "https://github.com/ErikBjare/TakeTheTime";
    maintainers = with lib.maintainers; [ huantian ];
    license = lib.licenses.mit;
=======
  meta = with lib; {
    description = "Simple time taking library using context managers";
    homepage = "https://github.com/ErikBjare/TakeTheTime";
    maintainers = with maintainers; [ huantian ];
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
