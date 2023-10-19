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
  version = "0.52.1";
  format = "setuptools";

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-+zGLWti99mYTyPkSxiYgE5RqVvEr2PGt8vFwesjcquo=";
  };

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
