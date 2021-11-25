{ lib, stdenv, fetchFromGitHub, autoreconfHook, libnet, libpcap }:

stdenv.mkDerivation rec {
  version = "2.22";
  pname = "arping";

  buildInputs = [ libnet libpcap ];

  src = fetchFromGitHub {
    owner = "ThomasHabets";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "sha256-yFSLhhyz6i7xyJR8Ax8FnHFGNe/HE40YirkkeefBqC4=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = with lib; {
    description = "Broadcasts a who-has ARP packet on the network and prints answers";
    homepage = "https://github.com/ThomasHabets/arping";
    license = with licenses; [ gpl2 ];
    maintainers = [ maintainers.michalrus ];
    platforms = platforms.unix;
  };
}
