{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, setuptools
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "sentinels";
  version = "1.0.0";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1cglkxph47pki4db4kjx5g4ikxp2milqdlcjgqwmx4p1gx6p1q3v";
  };

  propagatedBuildInputs = [
    setuptools
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "sentinels" ];

  meta = with lib; {
    homepage = "https://github.com/vmalloc/sentinels/";
    description = "Various objects to denote special meanings in python";
    license = licenses.bsd3;
    maintainers = with maintainers; [ gador ];
  };
}
