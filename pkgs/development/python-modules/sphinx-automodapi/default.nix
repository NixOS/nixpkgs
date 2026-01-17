{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchurl,
  setuptools-scm,
  git,
  sphinx,
  pytestCheckHook,
  cython,
  gcc,
  graphviz,
}:

buildPythonPackage rec {
  pname = "sphinx-automodapi";
  version = "0.22.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "astropy";
    repo = "sphinx-automodapi";
    tag = "v${version}";
    hash = "sha256-L+noKcyhT3wsbgdgyd29I9yCN81BlB8Fvfyl4fKioEw=";
    leaveDotGit = true;
  };

  build-system = [ setuptools-scm ];

  nativeBuildInputs = [ git ];

  dependencies = [ sphinx ];

  # https://github.com/astropy/sphinx-automodapi/issues/155
  testInventory = fetchurl {
    # Originally: https://docs.python.org/3/objects.inv
    url = "https://web.archive.org/web/20221007193144/https://docs.python.org/3/objects.inv";
    hash = "sha256-1cbUmdJJSoifkiIYa70SxnLsaK3F2gvnTEWo9vo/6rY=";
  };

  postPatch = ''
    substituteInPlace sphinx_automodapi/tests/{helpers,test_cases}.py \
      --replace ", None)" ", (None, '${testInventory}'))"
  '';

  nativeCheckInputs = [
    pytestCheckHook
    cython
    gcc
    graphviz
  ];

  pythonImportsCheck = [ "sphinx_automodapi" ];

  meta = {
    description = "Sphinx extension for generating API documentation";
    homepage = "https://github.com/astropy/sphinx-automodapi";
    changelog = "https://github.com/astropy/sphinx-automodapi/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ lovesegfault ];
  };
}
