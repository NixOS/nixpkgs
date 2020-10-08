{ lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "ssh-audit";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "jtesta";
    repo = pname;
    rev = "v${version}";
    sha256 = "1z1h9nsgfaxdnkr9dvc0yzc23b3wz436rg2fycg2glwjhhal8az7";
  };

  postPatch = ''
    cp ./README.md pypi/sshaudit/
    cp ./ssh-audit.py pypi/sshaudit/sshaudit.py
    mv pypi/* .
    ls -lah
  '';

  checkInputs = with python3Packages; [
    pytestCheckHook
  ];

  disabledTests = [
    "test_resolve_error"
    "test_resolve_hostname_without_records"
    "test_resolve_ipv4"
    "test_resolve_ipv6"
    "test_resolve_ipv46_both"
    "test_resolve_ipv46_order"
    "test_invalid_host"
    "test_invalid_port"
    "test_not_connected_socket"
    "test_ssh2_server_simple"
  ];

  meta = with lib; {
    description = "Tool for ssh server auditing";
    homepage = "https://github.com/jtesta/ssh-audit";
    license = licenses.mit;
    maintainers = with maintainers; [ tv ];
  };
}
