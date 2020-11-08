{ lib, buildPythonApplication, python3Packages, fetchFromGitHub }:

buildPythonApplication rec {
  pname = "vpn-slice";
  version = "0.14";

  src = fetchFromGitHub {
    owner = "dlenski";
    repo = pname;
    rev = "v${version}";
    sha256 = "1z2mdl3arzl95zrj4ir57f762gcimmmq5nk91j679cshxz4snxyr";
  };

  requiredPythonModules = with python3Packages; [ setproctitle dnspython ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/dlenski/vpn-slice";
    description =
      "vpnc-script replacement for easy and secure split-tunnel VPN setup";
    license = licenses.gpl3;
    maintainers = with maintainers; [ jdbaldry ];
  };
}
