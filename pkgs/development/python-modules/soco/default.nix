{
  lib,
  appdirs,
  buildPythonPackage,
  fetchFromGitHub,
  graphviz,
  ifaddr,
  lxml,
  mock,
  nix-update-script,
  pytestCheckHook,
  pythonOlder,
  requests,
  requests-mock,
  setuptools,
  xmltodict,
}:

buildPythonPackage rec {
  pname = "soco";
  version = "0.30.9";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "SoCo";
    repo = "SoCo";
    tag = "v${version}";
    hash = "sha256-nyzrBvl6VnNA8cMYtKIvB7k95g5AUixz93Ptc8rQ2pM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    appdirs
    ifaddr
    lxml
    requests
    xmltodict
  ];

  nativeCheckInputs = [
    pytestCheckHook
    graphviz
    mock
    requests-mock
  ];

  pythonImportsCheck = [ "soco" ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "CLI and library to control Sonos speakers";
    homepage = "http://python-soco.com/";
    changelog = "https://github.com/SoCo/SoCo/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ lovesegfault ];
  };
}
