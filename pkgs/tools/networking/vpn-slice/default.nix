{ lib, buildPythonApplication, nix-update-script, python3Packages, fetchFromGitHub }:

buildPythonApplication rec {
  pname = "vpn-slice";
  version = "0.16";

  src = fetchFromGitHub {
    owner = "dlenski";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-szJLw+TtpYcTaqeOTzMiQ0HVjNb9A5SLL4mGMX8xUnw=";
  };

  propagatedBuildInputs = with python3Packages; [ setproctitle dnspython ];

  doCheck = false;

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };

  meta = with lib; {
    homepage = "https://github.com/dlenski/vpn-slice";
    description =
      "vpnc-script replacement for easy and secure split-tunnel VPN setup";
    license = licenses.gpl3;
    maintainers = with maintainers; [ jdbaldry ];
  };
}
