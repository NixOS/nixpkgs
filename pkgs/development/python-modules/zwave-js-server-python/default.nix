{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pydantic
, pytest-aiohttp
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "zwave-js-server-python";
  version = "0.54.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-FdA8GHwe/An53CqPxE6QUwXTxk3HSqLBrk1dMaVWamA=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    aiohttp
    pydantic
  ];

  nativeCheckInputs = [
    pytest-aiohttp
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "zwave_js_server"
  ];

  meta = with lib; {
    description = "Python wrapper for zwave-js-server";
    homepage = "https://github.com/home-assistant-libs/zwave-js-server-python";
    changelog = "https://github.com/home-assistant-libs/zwave-js-server-python/releases/tag/${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
