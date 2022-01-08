{ lib
, buildPythonPackage
, fetchFromGitHub
, graphviz
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
  version = "0.25.2";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "SoCo";
    repo = "SoCo";
    rev = "v${version}";
    sha256 = "sha256-Bu9RtzvQVDPekIzkVvcDkTs5Z+IDx6lSBCMv5zs8gNA=";
  };

  propagatedBuildInputs = [
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

  pythonImportsCheck = [ "soco" ];

  passthru.updateScript = nix-update-script {
    attrPath = "python3Packages.${pname}";
  };

  meta = with lib; {
    homepage = "http://python-soco.com/";
    description = "A CLI and library to control Sonos speakers";
    license = licenses.mit;
    maintainers = with maintainers; [ lovesegfault ];
  };
}
