{
  lib,
  buildPythonPackage,
  docker,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  requests,
  responses,
}:

buildPythonPackage (finalAttrs: {
  pname = "securityreporter";
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dongit-org";
    repo = "python-reporter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bM11ztDd7Zg0O2+yGn9ZxKSo3B8nvhqUHSmdea/6sTg=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${finalAttrs.version}"'
  '';

  build-system = [ poetry-core ];

  dependencies = [ requests ];

  nativeCheckInputs = [
    docker
    pytestCheckHook
    responses
  ];

  pythonImportsCheck = [ "reporter" ];

  disabledTestPaths = [
    # Test require a running Docker instance
    "tests/functional/"
  ];

  meta = {
    description = "Python wrapper for the Reporter API";
    homepage = "https://github.com/dongit-org/python-reporter";
    changelog = "https://github.com/dongit-org/python-reporter/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
