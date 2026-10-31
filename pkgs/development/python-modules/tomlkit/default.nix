{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  poetry-core,

  # tests
  pytestCheckHook,
  pyyaml,

  # passthru.tests
  remarshal,
  tomlkit,
}:

buildPythonPackage (finalAttrs: {
  pname = "tomlkit";
  version = "0.15.2";
  pyproject = true;

  # github fetcher causes infinite recursion via gtk-doc
  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-g+MnVbodINk0C9Bp7pfp9iMrojRrY//LpCXeAffjJ6Y=";
  };

  build-system = [ poetry-core ];

  doCheck = false; # infinite recursion via pytest

  nativeCheckInputs = [
    pyyaml
    pytestCheckHook
  ];

  pythonImportsCheck = [ "tomlkit" ];

  passthru.tests = {
    inherit remarshal;
    pytest = tomlkit.overrideAttrs { doCheck = true; };
  };

  meta = {
    homepage = "https://github.com/python-poetry/tomlkit";
    changelog = "https://github.com/python-poetry/tomlkit/blob/${finalAttrs.version}/CHANGELOG.md";
    description = "Style-preserving TOML library for Python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      dotlambda
      jakewaksbaum
    ];
  };
})
