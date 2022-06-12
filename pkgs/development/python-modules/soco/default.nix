{ lib
, buildPythonPackage
, fetchFromGitHub
, graphviz
, appdirs
, ifaddr
, pythonOlder
, mock
, nix-update-script
, pytestCheckHook
, requests
, requests-mock
, xmltodict
}:

buildPythonPackage rec {
  pname = "soco";
  version = "0.27.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "SoCo";
    repo = "SoCo";
    rev = "v${version}";
    hash = "sha256-8U7wfxqen+hgK8j9ooPHCAKvd9kSZicToTyP7XzQFrg=";
  };

  propagatedBuildInputs = [
    appdirs
    ifaddr
    requests
    xmltodict
  ];

  checkInputs = [
    pytestCheckHook
    graphviz
    mock
    requests-mock
  ];

  pythonImportsCheck = [
    "soco"
  ];

  passthru.updateScript = nix-update-script {
    attrPath = "python3Packages.${pname}";
  };

  meta = with lib; {
    description = "CLI and library to control Sonos speakers";
    homepage = "http://python-soco.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ lovesegfault ];
  };
}
