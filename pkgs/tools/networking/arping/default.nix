{ lib, stdenv, fetchFromGitHub, autoreconfHook, libnet, libpcap }:

stdenv.mkDerivation rec {
  version = "2.23";
  pname = "arping";

  buildInputs = [ libnet libpcap ];

  src = fetchFromGitHub {
    owner = "ThomasHabets";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "sha256-Yn0EFb23VJvcVluQhwGHg9cdnZ8LKlBEds7cq8Irftc=";
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
