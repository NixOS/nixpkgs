{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pydantic
, pytest-aiohttp
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "zwave-js-server-python";
  version = "0.47.3";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-TJXzB6w1Kp2cT3sRMtMyL0Nx3ZEUeaHfL0P+qC88ohU=";
  };

  propagatedBuildInputs = [
    aiohttp
    pydantic
  ];

  doCheck = lib.versionAtLeast pytest-aiohttp.version "1.0.0";

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
