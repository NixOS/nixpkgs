{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, numpy
}:

buildPythonPackage rec {
  pname = "sipyco";
  version = "1.4";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "m-labs";
    repo = "sipyco";
    rev = "refs/tags/v${version}";
    hash = "sha256-sEYWtp11piUIa8YyuTOdFIIJ2GfcrUb+HEzPVKr4hW8=";
  };

  propagatedBuildInputs = [
    numpy
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "sipyco"
  ];

  meta = with lib; {
    description = "Simple Python Communications - used by the ARTIQ experimental control package";
    homepage = "https://github.com/m-labs/sipyco";
    changelog = "https://github.com/m-labs/sipyco/releases/tag/v${version}";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ charlesbaynham ];
  };
}
