{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, importlib-metadata
, sphinx
, pyenchant
, pbr
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-spelling";
  version = "7.7.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VlYcP2oVWwlGkU5N6YhymFkxVyncGBteTcimj+eN41o=";
  };

  nativeBuildInputs = [
    pbr
  ];

  propagatedBuildInputs = [
    sphinx
    pyenchant
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  # No tests included
  doCheck = false;

  pythonImportsCheck = [
    "sphinxcontrib.spelling"
  ];

  meta = with lib; {
    description = "Sphinx spelling extension";
    homepage = "https://github.com/sphinx-contrib/spelling";
    changelog = "https://github.com/sphinx-contrib/spelling/blob/${version}/docs/source/history.rst";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
  };
}
