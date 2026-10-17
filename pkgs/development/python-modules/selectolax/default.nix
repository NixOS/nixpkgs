{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  replaceVars,
  setuptools,
  cython,
  lexbor,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "selectolax";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rushter";
    repo = "selectolax";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VIlPjfH5shtxwZcw7JsMsNSxLibYmeHAUyy5AZPqYx8=";
  };

  patches = [
    (replaceVars ./0001-setup.py-devendor-lexbor.patch {
      lexbor = lib.getDev lexbor;
    })
  ];

  build-system = [
    setuptools
    cython
  ];

  buildInputs = [
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
    description = "Python binding to Lexbor engine. Fast HTML5 parser with CSS selectors for Python";
    homepage = "https://github.com/rushter/selectolax";
    changelog = "https://github.com/rushter/selectolax/blob/${finalAttrs.src.tag}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ marcel ];
  };
})
