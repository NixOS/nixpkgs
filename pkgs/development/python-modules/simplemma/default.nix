{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,

  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "simplemma";
  version = "1.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "adbar";
    repo = "simplemma";
    rev = "refs/tags/v${version}";
    hash = "sha256-lhk6QrBg0m8orYHphnP+YiCnJFE44buyp3NQbz0U550=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "simplemma" ];

  meta = with lib; {
    description = "Simple multilingual lemmatizer for Python, especially useful for speed and efficiency";
    homepage = "https://github.com/adbar/simplemma";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
