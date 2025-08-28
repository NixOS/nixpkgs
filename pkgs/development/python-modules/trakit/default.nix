{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

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

buildPythonPackage rec {
  pname = "trakit";
  version = "0.2.5";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "ratoaq2";
    repo = "trakit";
    tag = version;
    hash = "sha256-x/83yRzvQ81+wS0lJr52KYBMoPvSVDr17ppxG/lSfUg=";
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
    changelog = "https://github.com/ratoaq2/trakit/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eljamm ];
  };
}
