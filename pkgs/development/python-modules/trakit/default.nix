{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build dependencies
  poetry-core,

  # dependencies
  babelfish,
  pyyaml,
  rebulk,
  unidecode,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "trakit";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ratoaq2";
    repo = "trakit";
    tag = finalAttrs.version;
    hash = "sha256-uKLuXkvyZWjCMx5MHlsTKvTJwHYYV+wnRyE+D8BtCC0=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    babelfish
    pyyaml
    rebulk
  ];

  nativeCheckInputs = [
    pytestCheckHook
    unidecode
  ];

  disabledTests = [
    # requires network access
    "test_generate_config"
  ];

  pythonImportsCheck = [ "trakit" ];

  meta = {
    description = "Guess additional information from track titles";
    homepage = "https://github.com/ratoaq2/trakit";
    changelog = "https://github.com/ratoaq2/trakit/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eljamm ];
  };
})
