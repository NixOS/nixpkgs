{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  replaceVars,
  setuptools,
  cython,
  modest,
  lexbor,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "selectolax";
  version = "0.4.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rushter";
    repo = "selectolax";
    tag = "v${version}";
    hash = "sha256-Et4v105XW06uvzzwic2tBft8ljDurTWIiuKPjCXJbx8=";
  };

  patches = [
    (replaceVars ./0001-setup.py-devendor-modest-and-lexbor.patch {
      modest = lib.getDev modest;
      lexbor = lib.getDev lexbor;
    })
  ];

  build-system = [
    setuptools
    cython
  ];

  buildInputs = [
    modest
    lexbor
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    # shadows name and breaks imports in tests
    rm -rf selectolax
  '';

  pythonImportsCheck = [
    "selectolax"
  ];

  meta = {
    description = "Python binding to Modest and Lexbor engines. Fast HTML5 parser with CSS selectors for Python";
    homepage = "https://github.com/rushter/selectolax";
    changelog = "https://github.com/rushter/selectolax/blob/${src.tag}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ marcel ];
  };
}
