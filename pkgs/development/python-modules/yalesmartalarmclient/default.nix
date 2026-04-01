{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  requests,
}:

buildPythonPackage rec {
  pname = "yalesmartalarmclient";
  version = "0.4.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "domwillcode";
    repo = "yale-smart-alarm-client";
    tag = "v${version}";
    hash = "sha256-a0rzPEixJXLBfN+kJRPYiJiHY1BKxg/mM14RO3RiVdA=";
  };

  build-system = [ poetry-core ];

  dependencies = [ requests ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "yalesmartalarmclient" ];

  meta = {
    description = "Python module to interface with Yale Smart Alarm Systems";
    homepage = "https://github.com/domwillcode/yale-smart-alarm-client";
    changelog = "https://github.com/domwillcode/yale-smart-alarm-client/releases/tag/v${version}";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
