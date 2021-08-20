{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pytest-aiohttp
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "zwave-js-server-python";
  version = "0.29.0";
  disabled = pythonOlder "3.8";


  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = pname;
    rev = version;
    sha256 = "sha256-lUrYmeRqN+4uCZp+jRIrv89nGVSecuD1bK4YOysK8Ls=";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  checkInputs = [
    pytest-aiohttp
    pytestCheckHook
  ];

  pythonImportsCheck = [ "zwave_js_server" ];

  meta = with lib; {
    description = "Python wrapper for zwave-js-server";
    homepage = "https://github.com/home-assistant-libs/zwave-js-server-python";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
