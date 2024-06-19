{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  netifaces,
  python-engineio,
  python-socketio,
  pythonOlder,
  pythonRelaxDepsHook,
}:

buildPythonPackage rec {
  pname = "sisyphus-control";
  version = "3.1.3";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "jkeljo";
    repo = "sisyphus-control";
    rev = "refs/tags/v${version}";
    hash = "sha256-FbZWvsm2NT9a7TgHKWh/LHPsse6NBLK2grlOtHDbV2Y=";
  };

  pythonRelaxDeps = [
    "python-engineio"
    "python-socketio"
  ];

  nativeBuildInputs = [ pythonRelaxDepsHook ];

  propagatedBuildInputs = [
    aiohttp
    netifaces
    python-engineio
    python-socketio
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "sisyphus_control" ];

  meta = with lib; {
    description = "Control your Sisyphus Kinetic Art Table";
    homepage = "https://github.com/jkeljo/sisyphus-control";
    changelog = "https://github.com/jkeljo/sisyphus-control/blob/${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
