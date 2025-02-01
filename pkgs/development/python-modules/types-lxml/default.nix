{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  lxml,
  pyright,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  setuptools-scm,
  typeguard,
  types-beautifulsoup4,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "types-lxml";
  version = "2024.02.09";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "abelcheung";
    repo = "types-lxml";
    rev = "refs/tags/${version}";
    hash = "sha256-vmRbzfwlGGxd64KX8j4B3O9c7kg7hXSsCEYq3WAFdmk=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    types-beautifulsoup4
    typing-extensions
  ];

  nativeCheckInputs = [
    lxml
    pyright
    pytestCheckHook
    typeguard
  ];

  pythonImportsCheck = [ "lxml-stubs" ];

  disabledTests = [
    # AttributeError: 'bytes' object has no attribute 'find_class'
    # https://github.com/abelcheung/types-lxml/issues/34
    "test_bad_methodfunc"
    "test_find_class"
    "test_find_rel_links"
    "test_iterlinks"
    "test_make_links_absolute"
    "test_resolve_base_href"
    "test_rewrite_links"
  ];

  meta = with lib; {
    description = "Complete lxml external type annotation";
    homepage = "https://github.com/abelcheung/types-lxml";
    changelog = "https://github.com/abelcheung/types-lxml/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
