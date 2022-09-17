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
  version = "0.41.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-V4QEsHkakqYsZ09Q8BJG9fhREdGboirF5sNxm8t+dAQ=";
  };

  propagatedBuildInputs = [
    aiohttp
    pydantic
  ];

  doCheck = lib.versionAtLeast pytest-aiohttp.version "1.0.0";

  checkInputs = [
    pytest-aiohttp
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "zwave_js_server"
  ];

  meta = with lib; {
    description = "Python wrapper for zwave-js-server";
    homepage = "https://github.com/home-assistant-libs/zwave-js-server-python";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
