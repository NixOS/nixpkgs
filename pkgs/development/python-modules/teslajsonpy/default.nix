{ lib
, aiohttp
, backoff
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, wrapt
}:

buildPythonPackage rec {
  pname = "teslajsonpy";
  version = "0.10.4";

  src = fetchFromGitHub {
    owner = "zabuldon";
    repo = pname;
    rev = "v${version}";
    sha256 = "18frynmy47i9c24mdy819y2dnjwmhnmkly5mbmhikpbmm6d0yjf1";
  };

  propagatedBuildInputs = [
    aiohttp
    backoff
    wrapt
  ];

  checkInputs = [ pytestCheckHook ];

  # Not all Home Assistant related check pass
  disabledTests = [ "test_values_on_init" ];
  pythonImportsCheck = [ "teslajsonpy" ];

  meta = with lib; {
    description = "Python library to work with Tesla API";
    homepage = "https://github.com/zabuldon/teslajsonpy";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
