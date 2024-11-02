{
  lib,
  astroid,
  beautifulsoup4,
  buildPythonPackage,
  crossplane,
  fetchFromGitHub,
  jellyfish,
  jproperties,
  jsonschema-specifications,
  jsonschema,
  luhn,
  lxml,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  semgrep,
  setuptools,
  typing-extensions,
  wrapt,
}:

buildPythonPackage rec {
  pname = "whispers";
  version = "2.4.0";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "adeptex";
    repo = "whispers";
    rev = "refs/tags/${version}";
    hash = "sha256-hmFz6RI52CylsBIqO14hFX+2bvrPjpUBnfoDyVh9TbU=";
  };

  pythonRelaxDeps = [
    "jellyfish"
    "semgrep"
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail '"pytest-runner"' ""
  '';

  build-system = [ setuptools ];

  dependencies = [
    astroid
    beautifulsoup4
    crossplane
    jellyfish
    jproperties
    jsonschema
    jsonschema-specifications
    luhn
    lxml
    pyyaml
    semgrep
    typing-extensions
    wrapt
  ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
  ];

  preCheck = ''
    # Some tests need the binary available in PATH
    export PATH=$out/bin:$PATH
  '';

  pythonImportsCheck = [ "whispers" ];

  disabledTests = [
    # AssertionErrors
    "test_pairs"
    "test_run"
    "test_ast_dump"
  ];

  meta = with lib; {
    description = "Tool to identify hardcoded secrets in static structured text";
    homepage = "https://github.com/adeptex/whispers";
    changelog = "https://github.com/adeptex/whispers/releases/tag/${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "whispers";
  };
}
