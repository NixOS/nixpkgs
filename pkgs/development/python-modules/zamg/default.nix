{
  lib,
  aiohttp,
  aresponses,
  async-timeout,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "zamg";
  version = "0.3.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "killer0071234";
    repo = "python-zamg";
    tag = "v${version}";
    hash = "sha256-j864+3c0GDDftdLqLDD0hizT54c0IgTjT77jOneXlq0=";
  };

  pythonRelaxDeps = [ "async-timeout" ];

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    async-timeout
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "zamg" ];

  disabledTests = [
    # Tests are outdated
    "test_update_fail_3"
    "test_properties_fail_2"
  ];

  meta = {
    description = "Library to read weather data from ZAMG Austria";
    homepage = "https://github.com/killer0071234/python-zamg";
    changelog = "https://github.com/killer0071234/python-zamg/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
