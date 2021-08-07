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
  version = "0.23.2";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "SoCo";
    repo = "SoCo";
    rev = "v${version}";
    sha256 = "0qq2k0xy8a5b54nk7h4ipkvq8dpzklhgcwcffhnlcnl1vhq2dh33";
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
