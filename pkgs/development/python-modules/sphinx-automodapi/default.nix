{ lib
, buildPythonPackage
, cython
, fetchFromGitHub
, fetchurl
, gcc
, graphviz
, pytestCheckHook
, pythonOlder
, sphinx
}:

buildPythonPackage rec {
  pname = "sphinx-automodapi";
  version = "0.16.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "astropy";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-7/b3PlgoqXyzmj4KDoHJf5gd3SUSiyhkpcDWl3u+0Bs=";
  };

  propagatedBuildInputs = [ sphinx ];

  # https://github.com/astropy/sphinx-automodapi/issues/155
  testInventory = fetchurl {
    # Originally: https://docs.python.org/3/objects.inv
    url = "https://web.archive.org/web/20221007193144/https://docs.python.org/3/objects.inv";
    hash = "sha256-1cbUmdJJSoifkiIYa70SxnLsaK3F2gvnTEWo9vo/6rY=";
  };

  postPatch = ''
    substituteInPlace "sphinx_automodapi/tests/helpers.py" \
      --replace '[0]), None)' "[0]), (None, '${testInventory}'))"

    substituteInPlace "sphinx_automodapi/tests/test_cases.py" \
      --replace '[0]), None)' "[0]), (None, '${testInventory}'))"
  '';

  nativeCheckInputs = [
    pytestCheckHook
    cython
    gcc
    graphviz
  ];

  pythonImportsCheck = [ "sphinx_automodapi" ];

  meta = with lib; {
    description = "Sphinx extension for generating API documentation";
    homepage = "https://github.com/astropy/sphinx-automodapi";
    license = licenses.bsd3;
    maintainers = with maintainers; [ lovesegfault ];
  };
}
