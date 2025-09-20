{
  lib,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  mock,
  pytestCheckHook,
  requests,
  pythonOlder,
  websocket-client,
}:

buildPythonPackage rec {
  pname = "waterfurnace";
  version = "1.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "sdague";
    repo = "waterfurnace";
    tag = "v${version}";
    sha256 = "sha256-lix8dU9PxlsXIzKNFuUJkd80cUYXfTXSnFLu1ULACkE=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest-runner'," ""
  '';

  propagatedBuildInputs = [
    click
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
    mainProgram = "waterfurnace-debug";
    homepage = "https://github.com/sdague/waterfurnace";
    changelog = "https://github.com/sdague/waterfurnace/blob/v${version}/HISTORY.rst";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
