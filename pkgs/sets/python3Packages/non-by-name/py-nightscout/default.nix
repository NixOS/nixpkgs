{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  python-dateutil,
  pytz,
}:

buildPythonPackage rec {
  pname = "py-nightscout";
  version = "1.3.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "marciogranzotto";
    repo = "py-nightscout";
    rev = "v${version}";
    hash = "sha256-s5gOyTJSx/0gUOtRrGQ1PfiNIsJVVmwPGBX2zEetVE8=";
  };

  propagatedBuildInputs = [
    python-dateutil
    pytz
    aiohttp
  ];

  nativeCheckInputs = [
    aioresponses
    pytestCheckHook
    pytest-asyncio
  ];

  pythonImportsCheck = [ "py_nightscout" ];

  meta = {
    description = "Python library that provides an interface to Nightscout";
    homepage = "https://github.com/marciogranzotto/py-nightscout";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
