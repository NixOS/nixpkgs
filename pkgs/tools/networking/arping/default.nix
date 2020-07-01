{ stdenv, fetchFromGitHub, autoreconfHook, libnet, libpcap }:

stdenv.mkDerivation rec {
  version = "2.21";
  pname = "arping";

  buildInputs = [ libnet libpcap ];

  src = fetchFromGitHub {
    owner = "ThomasHabets";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "1i7rjn863bnq51ahbvypm1bkzhyshlm5b32yzdd9iaqyz7sa7pa7";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = with stdenv.lib; {
    description = "Broadcasts a who-has ARP packet on the network and prints answers";
    homepage = "https://github.com/ThomasHabets/arping";
    license = with licenses; [ gpl2 ];
    maintainers = [ maintainers.michalrus ];
    platforms = platforms.unix;
  };
}
