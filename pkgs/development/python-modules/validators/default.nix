{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, decorator
, six
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "validators";
  version = "0.20.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JBSM5OZBAKLV4mcjPiPnr+tVMWtH0w+q5+tucpK8Imo=";
  };

  propagatedBuildInputs = [
    decorator
    six
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Python Data Validation for Humans™";
    homepage = "https://github.com/kvesteri/validators";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
