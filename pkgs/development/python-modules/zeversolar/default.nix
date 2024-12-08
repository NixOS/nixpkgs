{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
  requests,
  retry2,
}:

buildPythonPackage rec {
  pname = "zeversolar";
  version = "0.3.2";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "kvanzuijlen";
    repo = "zeversolar";
    rev = "refs/tags/${version}";
    hash = "sha256-HnF21B7k2MmugMjGIF2EKwwXJWD/WdDvPdz1oaPSS5Y=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    requests
    retry2
  ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "zeversolar" ];

  meta = {
    description = "Module to interact with the local CGI provided by ZeverSolar";
    homepage = "https://github.com/kvanzuijlen/zeversolar";
    changelog = "https://github.com/kvanzuijlen/zeversolar/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
