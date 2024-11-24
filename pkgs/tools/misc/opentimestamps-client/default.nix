{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "opentimestamps-client";
  version = "0.7.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "opentimestamps";
    repo = "opentimestamps-client";
    rev = "refs/tags/opentimestamps-client-v${version}";
    hash = "sha256-0dWaXetRlF1MveBdJ0sAdqJ5HCdn08gkbX+nen/ygsQ=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    appdirs
    gitpython
    opentimestamps
    pysocks
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "otsclient"
  ];

  meta = with lib; {
    description = "Command-line tool to create and verify OpenTimestamps proofs";
    homepage = "https://github.com/opentimestamps/opentimestamps-client";
    changelog = "https://github.com/opentimestamps/opentimestamps-client/releases/tag/opentimestamps-client-v${version}";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ erikarvstedt ];
  };
}
