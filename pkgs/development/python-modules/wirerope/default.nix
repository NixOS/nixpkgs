{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  six,
  nix-update-script,
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage rec {
  pname = "wirerope";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "youknowone";
    repo = "wirerope";
    rev = version;
    hash = "sha256-oojnv+2+nwL/TJhN+QZ5eiV6WGHC3SCxBQrCri0aHQc=";
  };

  build-system = [ setuptools ];

  dependencies = [ six ];

  pythonImportsCheck = [ "wirerope" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Wrappers for class callables";
    homepage = "https://github.com/youknowone/wirerope";
    changelog = "https://github.com/youknowone/wirerope/releases/tag/${version}";
    license = licenses.bsd2WithViews;
    maintainers = with maintainers; [ pbsds ];
  };
}
