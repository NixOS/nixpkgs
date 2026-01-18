{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  cssselect,
  fetchFromGitHub,
  html5lib,
  hypothesis,
  lxml,
  mypy,
  pdm-backend,
  pook,
  pyright,
  pytestCheckHook,
  typeguard,
  types-html5lib,
  typing-extensions,
  urllib3,
}:

buildPythonPackage rec {
  pname = "types-lxml";
  version = "2026.01.01";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "abelcheung";
    repo = "types-lxml";
    tag = version;
    hash = "sha256-odkIwuh2VxDliRd6cPTCBSz19zxIBOBlVN0Sisngkn0=";
  };

  pythonRelaxDeps = [ "beautifulsoup4" ];

  build-system = [ pdm-backend ];

  dependencies = [
    cssselect
    beautifulsoup4
    types-html5lib
    typing-extensions
  ];

  optional-dependencies = {
    mypy = [ mypy ];
    pyright = [ pyright ];
  };

  nativeCheckInputs = [
    beautifulsoup4
    html5lib
    hypothesis
    lxml
    pook
    pytestCheckHook
    typeguard
    urllib3
  ]
  ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "lxml-stubs" ];

  # there may only be one conftest.py
  preCheck = ''
    rm -r tests/static
    mv tests/runtime/* tests/
    rmdir tests/runtime
    substituteInPlace tests/conftest.py \
      --replace-fail '"pytest-revealtype-injector",' "" \
      --replace-fail 'runtime.register_strategy' 'tests.register_strategy'
  '';

  disabledTests = [
    "test_single_ns_all_tag_2"
    "test_default_ns"
    # Tests require network access
    "TestRelaxNGInput"
    "TestXmldtdid"
    "TestIddict"
    "TestParseid"
  ];

  meta = {
    description = "Complete lxml external type annotation";
    homepage = "https://github.com/abelcheung/types-lxml";
    changelog = "https://github.com/abelcheung/types-lxml/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
