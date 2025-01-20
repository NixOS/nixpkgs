{
  lib,
  astroid,
  beautifulsoup4,
  buildPythonPackage,
  crossplane,
  fetchFromGitHub,
  jellyfish,
  jproperties,
  luhn,
  lxml,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  wrapt,
  semgrep,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "whispers";
  version = "2.4.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "adeptex";
    repo = "whispers";
    tag = version;
    hash = "sha256-hmFz6RI52CylsBIqO14hFX+2bvrPjpUBnfoDyVh9TbU=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail '"pytest-runner"' ""
  '';

  pythonRelaxDeps = [
    "jellyfish"
    "lxml"
    "pyyaml"
    "semgrep"
    "six"
    "wrapt"
  ];

  build-system = [ setuptools ];

  dependencies = [
    astroid
    beautifulsoup4
    crossplane
    jellyfish
    jproperties
    luhn
    lxml
    pyyaml
    semgrep
    six
    wrapt
  ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
  ];

  disabledTestPaths = [
    # pinning tests highly sensitive to semgrep version
    "tests/unit/plugins/test_semgrep.py"
  ];

  preCheck = ''
    # pinning test highly sensitive to semgrep version
    substituteInPlace tests/unit/test_main.py \
      --replace-fail '("--ast", 421),' ""

    # Some tests need the binary available in PATH
    export PATH=$out/bin:$PATH
  '';

  pythonImportsCheck = [ "whispers" ];

  meta = with lib; {
    description = "Tool to identify hardcoded secrets in static structured text";
    homepage = "https://github.com/adeptex/whispers";
    changelog = "https://github.com/adeptex/whispers/releases/tag/${src.tag}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "whispers";
  };
}
