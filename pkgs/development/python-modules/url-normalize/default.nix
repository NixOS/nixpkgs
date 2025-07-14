{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  idna,
  pytest-cov-stub,
  pytest-socket,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "url-normalize";
  version = "2.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "niksite";
    repo = "url-normalize";
    tag = "v${version}";
    hash = "sha256-ZFY1KMEHvteMFVM3QcYjCiTz3dLxRWyv/dZQMzVxGvo=";
  };

  build-system = [ setuptools ];

  dependencies = [ idna ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytest-socket
    pytestCheckHook
  ];

  pythonImportsCheck = [ "url_normalize" ];

  meta = {
    changelog = "https://github.com/niksite/url-normalize/blob/${src.tag}/CHANGELOG.md";
    description = "URL normalization for Python";
    homepage = "https://github.com/niksite/url-normalize";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
