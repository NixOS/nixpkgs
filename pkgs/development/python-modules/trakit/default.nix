{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  nix-update-script,

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
  version = "0.2.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "ratoaq2";
    repo = "trakit";
    rev = version;
    hash = "sha256-VV+pdsQ5WEALYZgu4AmvNce1rCTLSYPZtTMjh+aExsU=";
  };

  nativeBuildInputs = [ poetry-core ];

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

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/ratoaq2/trakit/releases/tag/${version}";
    description = "Guess additional information from track titles";
    homepage = "https://github.com/ratoaq2/trakit";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eljamm ];
  };
}
