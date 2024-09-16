{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  six,
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage rec {
  pname = "wirerope";
  version = "0.4.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "youknowone";
    repo = "wirerope";
    rev = version;
    hash = "sha256-Xi6I/TXttjCregknmZUhV5GAiNR/HmEi4wCZiCmp0DQ=";
  };

  build-system = [ setuptools ];

  dependencies = [ six ];

  pythonImportsCheck = [ "wirerope" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  meta = with lib; {
    description = "Wrappers for class callables";
    homepage = "https://github.com/youknowone/wirerope";
    changelog = "https://github.com/youknowone/wirerope/releases/tag/${version}";
    license = licenses.bsd2WithViews;
    maintainers = with maintainers; [ pbsds ];
  };
}
