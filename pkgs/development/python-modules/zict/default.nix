{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pytest-asyncio,
  pytest-repeat,
  pytest-timeout,
  setuptools,
}:

buildPythonPackage rec {
  pname = "zict";
  version = "3.0.0";
  pyproject = true;

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

  meta = {
    description = "Mutable mapping tools";
    homepage = "https://github.com/dask/zict";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ teh ];
  };
}
