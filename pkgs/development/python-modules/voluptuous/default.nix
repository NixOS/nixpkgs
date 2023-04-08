{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "voluptuous";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "alecthomas";
    repo = pname;
    rev = version;
    hash = "sha256-cz3Bd+/yPh+VOHxzi/W+gbDh/H5Nl/n4jvxDOirmAVk=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "voluptuous"
  ];

  pytestFlagsArray = [
    "voluptuous/tests/"
  ];

  meta = with lib; {
    description = "Python data validation library";
    homepage = "http://alecthomas.github.io/voluptuous/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
