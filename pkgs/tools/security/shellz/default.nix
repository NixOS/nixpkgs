{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "shellz";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "evilsocket";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-sUYDopSxaUPyrHev8XXobRoX6uxbdf5goJ75KYEPFNY=";
  };

  vendorHash = "sha256-9uQMimttsNCA//DgDMuukXUROlIz3bJfr04XfVpPLZM=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Utility to manage your SSH, telnet, kubernetes, winrm, web or any custom shell";
    homepage = "https://github.com/evilsocket/shellz";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
