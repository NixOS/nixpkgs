{
  lib,
  buildPythonPackage,
  fetchPypi,
  six,
}:

buildPythonPackage rec {
  pname = "serpy";
  version = "0.3.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-N3KyqZI/v2dAAP9Rq+v26o8Pygos/L+g1j/xGBk9HsU=";
  };

  propagatedBuildInputs = [ six ];

  # ImportError: No module named 'tests
  doCheck = false;

  pythonImportsCheck = [ "serpy" ];

  meta = {
    description = "Ridiculously fast object serialization";
    homepage = "https://github.com/clarkduvall/serpy";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
