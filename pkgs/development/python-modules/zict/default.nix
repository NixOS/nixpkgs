{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pytest-asyncio,
  pytest-repeat,
  pytest-timeout,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "zict";
  version = "3.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4yHiY7apeq/AeQw8+zwEZWtwZuZzjDf//MqV2APJ+6U=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    pytest-repeat
    pytest-timeout
  ];

<<<<<<< HEAD
  meta = {
    description = "Mutable mapping tools";
    homepage = "https://github.com/dask/zict";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ teh ];
=======
  meta = with lib; {
    description = "Mutable mapping tools";
    homepage = "https://github.com/dask/zict";
    license = licenses.bsd3;
    maintainers = with maintainers; [ teh ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
