{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "voluptuous";
  version = "0.14.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "alecthomas";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-7KXuypcKoqZboHTzoNKK5sYUR57wWGJu6y9zkLecep0=";
  };

  nativeBuildInputs = [
    setuptools
  ];

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
    downloadPage = "https://github.com/alecthomas/voluptuous";
    homepage = "http://alecthomas.github.io/voluptuous/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
