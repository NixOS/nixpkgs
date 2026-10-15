{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "check-openvpn";
  version = "0.0.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "liquidat";
    repo = "nagios-icinga-openvpn";
    rev = version;
    hash = "sha256-9dJw0SGzvJ9drE/53wRs1sPp73c9VGuAK7Owyey54+8=";
  };

  # no tests
  doCheck = false;

  meta = {
    description = "Nagios/icinga/sensu check plugin for OpenVPN";
    homepage = "https://github.com/liquidat/nagios-icinga-openvpn";
    license = lib.licenses.mit;
    mainProgram = "check_openvpn";
    maintainers = with lib.maintainers; [ peterhoeg ];
  };
}
