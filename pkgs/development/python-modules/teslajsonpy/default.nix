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
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "zabuldon";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-yfaUa12doOvdFkbHHdOYcFcu86hYZtt2i0tya2ENjf4=";
  };

  propagatedBuildInputs = [
    aiohttp
    backoff
    wrapt
  ];

  checkInputs = [ pytestCheckHook ];

  # Not all Home Assistant related check pass
  # https://github.com/zabuldon/teslajsonpy/issues/121
  # https://github.com/zabuldon/teslajsonpy/pull/124
  disabledTests = [
    "test_values_on_init"
    "test_get_value_on_init"
  ];
  pythonImportsCheck = [ "teslajsonpy" ];

  meta = with lib; {
    description = "Python library to work with Tesla API";
    homepage = "https://github.com/zabuldon/teslajsonpy";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
