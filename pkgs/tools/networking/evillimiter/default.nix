{ lib
, buildPythonApplication
, fetchFromGitHub
, colorama
, iproute2
, iptables
, netaddr
, netifaces
, scapy
, terminaltables
, tqdm
}:

buildPythonApplication rec {
  pname = "evillimiter";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "bitbrute";
    repo = pname;
    rev = "v${version}";
    sha256 = "1l0acd4a36wzz1gyc6mcw3zpagyi2mc425c6d4c6anq3jxwm3847";
  };

  propagatedBuildInputs = [
    colorama
    iproute2
    iptables
    netaddr
    netifaces
    scapy
    terminaltables
    tqdm
  ];

  # no tests present
  doCheck = false;

  pythonImportsCheck = [ "evillimiter.evillimiter" ];

  meta = with lib; {
    description = "Tool that monitors, analyzes and limits the bandwidth";
    mainProgram = "evillimiter";
    longDescription = ''
      A tool to monitor, analyze and limit the bandwidth (upload/download) of
      devices on your local network without physical or administrative access.
      evillimiter employs ARP spoofing and traffic shaping to throttle the
      bandwidth of hosts on the network.
    '';
    homepage = "https://github.com/bitbrute/evillimiter";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
