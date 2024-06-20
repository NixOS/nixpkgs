{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "unidecode";
  version = "1.3.8";
  pyproject = true;

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "avian2";
    repo = "unidecode";
    rev = "refs/tags/${pname}-${version}";
    hash = "sha256-OoJSY+dNNISyVwKuRboMH7Je8nYFKxus2c4v3VsmyRE=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "unidecode" ];

  meta = with lib; {
    description = "ASCII transliterations of Unicode text";
    mainProgram = "unidecode";
    homepage = "https://github.com/avian2/unidecode";
    changelog = "https://github.com/avian2/unidecode/blob/unidecode-${version}/ChangeLog";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ domenkozar ];
  };
}
