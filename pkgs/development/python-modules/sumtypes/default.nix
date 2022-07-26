{ lib
, attrs
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "sumtypes";
  version = "0.1a6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "radix";
    repo = pname;
    rev = version;
    sha256 = "sha256-qwQyFKVnGEqHUqFmUSnHVvedsp2peM6rJZcS90paLOo=";
  };

  propagatedBuildInputs = [
    attrs
  ];

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Algebraic data types for Python";
    homepage = "https://github.com/radix/sumtypes";
    license = licenses.mit;
    maintainers = with maintainers; [ NieDzejkob ];
  };
}
