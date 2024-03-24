{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "check-openvpn";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "liquidat";
    repo = "nagios-icinga-openvpn";
    rev = version;
    sha256 = "1vz3p7nckc5k5f06nm1xfzpykhyndh2dzyagmifrzg5k478p1lpm";
  };

  # no tests
  doCheck = false;

  meta = {
    description = "Nagios/icinga/sensu check plugin for OpenVPN";
    license = lib.licenses.mit;
    mainProgram = "check_openvpn";
    maintainers = with lib.maintainers; [ peterhoeg ];
  };
}
