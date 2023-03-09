{ lib
, buildPythonPackage
, click
, fetchFromGitHub
, mock
, pytest-runner
, pytestCheckHook
, requests
, websocket-client
}:

buildPythonPackage rec {
  pname = "waterfurnace";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "sdague";
    repo = pname;
    rev = "v${version}";
    sha256 = "1ba247fw1fvi7zy31zj2wbjq7fajrbxhp139cl9jj67rfvxfv8xf";
  };

  propagatedBuildInputs = [
    click
    pytest-runner
    requests
    websocket-client
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "waterfurnace" ];

  meta = with lib; {
    description = "Python interface to waterfurnace geothermal systems";
    homepage = "https://github.com/sdague/waterfurnace";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
