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

buildPythonPackage (finalAttrs: {
  pname = "url-normalize";
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "niksite";
    repo = "url-normalize";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RZORbZfeRfzGJFsLXJUuqXVFsD8TfcHzjBGb80cTetQ=";
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
    description = "URL normalization for Python";
    homepage = "https://github.com/niksite/url-normalize";
    changelog = "https://github.com/niksite/url-normalize/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
