{ lib
, aiohttp
, backoff
, beautifulsoup4
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pytest-asyncio
, pytestCheckHook
, wrapt
}:

buildPythonPackage rec {
  pname = "teslajsonpy";
  version = "0.11.5";

  src = fetchFromGitHub {
    owner = "zabuldon";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-s0IZ1UNldYddaR3zJoYS6ey8Kjxd1fr4fOwf0gNNbow=";
  };

  patches = [
    (fetchpatch {
      name = "dont-use-dummpy-module-bs4.patch";
      url = "https://github.com/zabuldon/teslajsonpy/pull/138/commits/f5a788e47d8338c8ebb06d954f802ba1ec614db3.patch";
      sha256 = "0rws7fhxmca8d5w0bkygx8scvzah3yvb3yfhn05qmp73mn3pmcb3";
    })
  ];

  propagatedBuildInputs = [
    aiohttp
    backoff
    beautifulsoup4
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
