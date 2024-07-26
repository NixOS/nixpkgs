{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, libnet
, libpcap
}:

stdenv.mkDerivation rec {
  pname = "arping";
  version = "2.25";

  src = fetchFromGitHub {
    owner = "ThomasHabets";
    repo = pname;
    rev = "${pname}-${version}";
    hash = "sha256-SAdbgPmApmFToYrAm8acUapZMEMQr5MO7bQOTO2hd2c=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    libnet
    libpcap
  ];

  meta = with lib; {
    description = "Broadcasts a who-has ARP packet on the network and prints answers";
    homepage = "https://github.com/ThomasHabets/arping";
    license = with licenses; [ gpl2Plus ];
    maintainers = with maintainers; [ michalrus ];
    platforms = platforms.unix;
    mainProgram = "arping";
  };
}
