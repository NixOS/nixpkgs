{ stdenv, fetchFromGitHub, autoreconfHook, libnet, libpcap }:

stdenv.mkDerivation rec {
  version = "2.20";
  pname = "arping";

  buildInputs = [ libnet libpcap ];

  src = fetchFromGitHub {
    owner = "ThomasHabets";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "0gmyip552k6mq7013cvy5yc4akn2rz28s3g4x4vdq35vnxf66cyk";
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
