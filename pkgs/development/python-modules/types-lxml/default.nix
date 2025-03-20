{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  cssselect,
  fetchFromGitHub,
  html5lib,
  lxml,
  pdm-backend,
  pyright,
  pytestCheckHook,
  pythonOlder,
  typeguard,
  types-beautifulsoup4,
  typing-extensions,
  hypothesis,
}:

buildPythonPackage rec {
  pname = "types-lxml";
  version = "2025.02.24";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "abelcheung";
    repo = "types-lxml";
    tag = version;
    hash = "sha256-LkE4APp1r8mTofaTfOvrc8qRHQYRs3VQhRrdXKdBW/Q=";
  };

  build-system = [ pdm-backend ];

  dependencies = [
    cssselect
    types-beautifulsoup4
    typing-extensions
  ];

  nativeCheckInputs = [
    beautifulsoup4
    html5lib
    hypothesis
    lxml
    pyright
    pytestCheckHook
    typeguard
  ];

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
  ];

  meta = with lib; {
    description = "Complete lxml external type annotation";
    homepage = "https://github.com/abelcheung/types-lxml";
    changelog = "https://github.com/abelcheung/types-lxml/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
