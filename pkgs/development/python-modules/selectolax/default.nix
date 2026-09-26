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

buildPythonPackage (finalAttrs: {
  pname = "selectolax";
  version = "0.4.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rushter";
    repo = "selectolax";
    tag = "v${finalAttrs.version}";
    hash = "sha256-t3kw1KM+wFZU0BNhEcCgnv/J6S2erXGKYd68bV1/uew=";
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

  # shadows name and breaks imports in tests
  preCheck = ''
    rm -rf selectolax
  '';

  pythonImportsCheck = [
    "selectolax"
  ];

  meta = {
    description = "Python binding to Modest and Lexbor engines. Fast HTML5 parser with CSS selectors for Python";
    homepage = "https://github.com/rushter/selectolax";
    changelog = "https://github.com/rushter/selectolax/blob/${finalAttrs.src.tag}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ marcel ];
  };
})
