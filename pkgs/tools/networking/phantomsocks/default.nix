{ lib
, buildGoModule
, fetchFromGitHub
, stdenv
, libpcap
  # Cann't be build with both pcap and rawsocket tags
, withPcap ? (!stdenv.isLinux && !withRawsocket)
, withRawsocket ? (stdenv.isLinux && !withPcap)
}:

buildGoModule rec {
  pname = "phantomsocks";
  version = "unstable-2023-11-30";

  src = fetchFromGitHub {
    owner = "macronut";
    repo = pname;
    rev = "b1b13c5b88cf3bac54f39c37c0ffcb0b46e31049";
    hash = "sha256-ptCzd2/8dNHjAkhwA2xpZH8Ki/9DnblHI2gAIpgM+8E=";
  };

  vendorHash = "sha256-0MJlz7HAhRThn8O42yhvU3p5HgTG8AkPM0ksSjWYAC4=";

  ldflags = [
    "-s"
    "-w"
  ];
  buildInputs = lib.optional withPcap libpcap;
  tags = lib.optional withPcap "pcap"
    ++ lib.optional withRawsocket "rawsocket";

  meta = with lib;{
    homepage = "https://github.com/macronut/phantomsocks";
    description = "Cross-platform proxy client/server for Linux/Windows/macOS";
    longDescription = ''
      A cross-platform proxy tool that could be used to modify TCP packets
      to implement TCB desync to bypass detection and censoring.
    '';
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ oluceps ];
    mainProgram = "phantomsocks";
  };
}
