{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "routersploit";
  version = "3.4.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "threat9";
    repo = "routersploit";
    rev = "refs/tags/v${version}";
    hash = "sha256-fJz2CWWOrRB1lwrjZzQ1/J1KbWXXDrOUfVmAYVA42pk=";
  };

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
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
    mainProgram = "rsf";
  };
}
