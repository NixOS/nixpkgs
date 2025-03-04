{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
  netifaces,
  poetry-core,
  python-engineio-v3,
  python-socketio-v4,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "sisyphus-control";
  version = "3.1.4";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "jkeljo";
    repo = "sisyphus-control";
    tag = "v${version}";
    hash = "sha256-1/trJ/mfiXljNt7ZIBwQ45mIBbqg68e29lvVsPDPzoU=";
  };

  patches = [
    # https://github.com/jkeljo/sisyphus-control/pull/9
    (fetchpatch2 {
      name = "specify-build-system.patch";
      url = "https://github.com/jkeljo/sisyphus-control/commit/dd48079e03a53cdb3af721de0d307209286c38f0.patch";
      hash = "sha256-573YLPrNbbMXSrZ3gK8cmHmuk2+UeggcKL/+eo4pgrs=";
    })
  ];

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    netifaces
    python-engineio-v3
    python-socketio-v4
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "sisyphus_control" ];

  meta = with lib; {
    description = "Control your Sisyphus Kinetic Art Table";
    homepage = "https://github.com/jkeljo/sisyphus-control";
    changelog = "https://github.com/jkeljo/sisyphus-control/blob/${src.rev}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
