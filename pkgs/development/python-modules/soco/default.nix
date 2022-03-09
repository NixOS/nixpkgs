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
  version = "0.26.4";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "SoCo";
    repo = "SoCo";
    rev = "v${version}";
    hash = "sha256-DoONq6Iqi8t47jtqggKYMHSNJAf/Kha3tszR6mYeB9Y=";
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
