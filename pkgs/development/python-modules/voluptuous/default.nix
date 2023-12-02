{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "voluptuous";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "alecthomas";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-7KXuypcKoqZboHTzoNKK5sYUR57wWGJu6y9zkLecep0=";
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
