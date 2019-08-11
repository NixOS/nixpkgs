{ stdenv, fetchFromGitHub, autoreconfHook, libnet, libpcap }:

stdenv.mkDerivation rec {
  version = "2.19";
  name = "arping-${version}";

  buildInputs = [ libnet libpcap ];

  src = fetchFromGitHub {
    owner = "ThomasHabets";
    repo = "arping";
    rev = "arping-${version}";
    sha256 = "10gpil6ic17x8v628vhz9s98rnw1k8ci2xs56i52pr103irirczw";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = with stdenv.lib; {
    description = "Broadcasts a who-has ARP packet on the network and prints answers";
    homepage = https://github.com/ThomasHabets/arping;
    license = with licenses; [ gpl2 ];
    maintainers = [ maintainers.michalrus ];
    platforms = platforms.unix;
  };
}
