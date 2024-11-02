{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,

  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "simplemma";
  version = "1.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "adbar";
    repo = "simplemma";
    rev = "refs/tags/v${version}";
    hash = "sha256-X0mqFPdCo0/sTexv4bi4bND7LFHOJvlOPH6tB39ybZY=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "simplemma" ];

  meta = with lib; {
    description = "Simple multilingual lemmatizer for Python, especially useful for speed and efficiency";
    homepage = "https://github.com/adbar/simplemma";
    license = licenses.mit;
    maintainers = [ ];
  };
}
