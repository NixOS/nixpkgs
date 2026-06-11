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
  version = "1.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dongit-org";
    repo = "python-reporter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XlM3xrQwfuKYkW9NJmNcq/9QiaUrJla5P1fjonqGkE8=";
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
