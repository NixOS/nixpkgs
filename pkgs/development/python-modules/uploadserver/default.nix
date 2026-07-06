{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  urllib3,
  requests,
  curl,
}:
buildPythonPackage (finalAttrs: {
  pname = "uploadserver";
  version = "6.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Densaugeo";
    repo = "uploadserver";
    tag = finalAttrs.version;
    hash = "sha256-3obQZF9dY9rRVpeU4362o3ZC95hQtXFhxSNryxPAoLM=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    urllib3
    requests
    curl
  ];

  env.VERBOSE = 0;
  env.PROTOCOL = "HTTP";
  enabledTestPaths = [ "test.py" ];

  pythonImportsCheck = [ "uploadserver" ];

  meta = {
    description = "Python's http.server extended to include a file upload page";
    homepage = "https://github.com/Densaugeo/uploadserver";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.gigamonster256 ];
    mainProgram = "uploadserver";
  };
})
