{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "routersploit";
  version = "unstable-2021-02-06";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "threat9";
    repo = pname;
    rev = "3fd394637f5566c4cf6369eecae08c4d27f93cda";
    hash = "sha256-IET0vL0VVP9ZNn75hKdTCiEmOZRHHYICykhzW2g3LEg=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    future
    paramiko
    pycryptodome
    pysnmp
    requests
    setuptools
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytest-xdist
    pytestCheckHook
    threat9-test-bed
  ];

  postInstall = ''
    mv $out/bin/rsf.py $out/bin/rsf
  '';

  pythonImportsCheck = [
    "routersploit"
  ];

  pytestFlagsArray = [
    "-n"
    "$NIX_BUILD_CORES"
    # Run the same tests as upstream does in the first round
    "tests/core/"
    "tests/test_exploit_scenarios.py"
    "tests/test_module_info.py"
  ];

  meta = with lib; {
    description = "Exploitation Framework for Embedded Devices";
    homepage = "https://github.com/threat9/routersploit";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
