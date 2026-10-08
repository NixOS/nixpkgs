{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  jinja2,
  jsonschema,
  nix-update-script,
  pyrefly,
  pyright,
  pyshacl,
  pytest-cov-stub,
  pytest-xdist,
  pytestCheckHook,
  rdflib,
  types-jsonschema,
}:

buildPythonPackage (finalAttrs: {
  pname = "shacl2code";
  version = "1.2.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "JPEWdev";
    repo = "shacl2code";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YGZLvJRoA0sMjTvYYChZMWtERjXLWgHe1WgzNEG9xGc=";
  };

  build-system = [ hatchling ];

  dependencies = [
    jinja2
    rdflib
  ];

  nativeCheckInputs = [
    jsonschema
    pyrefly
    pyright
    pyshacl
    pytest-cov-stub
    pytest-xdist
    pytestCheckHook
    types-jsonschema
  ];

  preCheck = ''
    export PATH="$out/bin:$PATH"
  '';

  pythonImportsCheck = [ "shacl2code" ];

  disabledTestPaths = [
    # Tests want to generate and run code
    "tests/test_context.py"
    "tests/test_cpp.py"
    "tests/test_golang.py"
    "tests/test_jsonschema.py"
    "tests/test_lint.py"
    "tests/test_python.py"
    "tests/test_rust.py"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Convert SHACL model to code bindings";
    homepage = "https://github.com/JPEWdev/shacl2code";
    changelog = "https://github.com/JPEWdev/shacl2code/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
