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
  version = "0.30.4";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "SoCo";
    repo = "SoCo";
    rev = "refs/tags/v${version}";
    hash = "sha256-t5Cxlm5HhN6WY6ty4i2MAtqjbC7DwZqSp1g5nybFAH4=";
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
