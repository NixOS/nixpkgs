{ lib
, aiohttp
, authcaptureproxy
, backoff
, beautifulsoup4
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, httpx
, poetry-core
, pytest-asyncio
, pytestCheckHook
, wrapt
}:

buildPythonPackage rec {
  pname = "teslajsonpy";
  version = "1.0.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "zabuldon";
    repo = pname;
    rev = "v${version}";
    sha256 = "0pb0kgddyzpipa0sqrkwyg1jgh95726irb306lr0pyyg0rsk54k7";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    authcaptureproxy
    aiohttp
    backoff
    beautifulsoup4
    httpx
    wrapt
  ];

  checkInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "teslajsonpy" ];

  meta = with lib; {
    description = "Python library to work with Tesla API";
    homepage = "https://github.com/zabuldon/teslajsonpy";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
