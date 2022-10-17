{ lib
, buildPythonPackage
, fetchFromGitHub
, graphviz
, appdirs
, ifaddr
, pythonOlder
, lxml
, mock
, nix-update-script
, pytestCheckHook
, requests
, requests-mock
, xmltodict
}:

buildPythonPackage rec {
  pname = "soco";
  version = "0.28.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "SoCo";
    repo = "SoCo";
    rev = "v${version}";
    hash = "sha256-rH6EfPK4EEQDO63VEIM7jJO5OM4tyYfZ5yYUskPf8dE=";
  };

  propagatedBuildInputs = [
    appdirs
    ifaddr
    lxml
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
