{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub

, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "simplemma";
  version = "0.9.1";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "adbar";
    repo = "simplemma";
    rev = "v${version}";
    hash = "sha256-2IvAJ+tRnlYISymYXznCGAoUTKkM/PoYwpZpuMSXRYQ=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "simplemma"
  ];

  meta = with lib; {
    description = "Simple multilingual lemmatizer for Python, especially useful for speed and efficiency";
    homepage = "https://github.com/adbar/simplemma";
    license = licenses.mit;
    maintainers = with maintainers; [ paveloom ];
  };
}
