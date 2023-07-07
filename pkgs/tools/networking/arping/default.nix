{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, libnet
, libpcap
}:

stdenv.mkDerivation rec {
  pname = "arping";
  version = "2.23";

  src = fetchFromGitHub {
    owner = "ThomasHabets";
    repo = pname;
    rev = "${pname}-${version}";
    hash = "sha256-Yn0EFb23VJvcVluQhwGHg9cdnZ8LKlBEds7cq8Irftc=";
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
  };
}
