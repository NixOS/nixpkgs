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
  version = "7.6.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-oSnV3QwAydQUvN9Zmv3bVbrgHx1UNjbn67CUkborq9Q=";
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
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
  };
}
