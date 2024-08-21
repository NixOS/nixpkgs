{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pythonOlder,
  requests,
}:

buildPythonPackage rec {
  pname = "yalesmartalarmclient";
  version = "0.4.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "domwillcode";
    repo = "yale-smart-alarm-client";
    rev = "refs/tags/v${version}";
    hash = "sha256-L9y8J0NIN1LWhzcpKY1Z4BPbCHUuLQz+3Bbq+qJJeak=";
  };

  build-system = [ poetry-core ];

  dependencies = [ requests ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "yalesmartalarmclient" ];

  meta = with lib; {
    description = "Python module to interface with Yale Smart Alarm Systems";
    homepage = "https://github.com/domwillcode/yale-smart-alarm-client";
    changelog = "https://github.com/domwillcode/yale-smart-alarm-client/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
