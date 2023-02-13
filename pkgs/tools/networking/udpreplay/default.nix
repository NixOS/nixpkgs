{ stdenv, cmake, libpcap, fetchFromGitHub, lib }:
stdenv.mkDerivation rec {
  pname = "updreplay";
  version = "1.0.0";
  nativeBuildInputs = [ cmake ];
  buildInputs = [ libpcap ];
  src = fetchFromGitHub {
    owner = "rigtorp";
    repo = "udpreplay";
    rev = "v${version}";
    hash = "sha256-8cp1RyVBnq3vx2LPkAx7ktmdLo0bSq9UWlbb/DrJxpc=";
  };

  meta = with lib; {
    description = "Replay UDP packets from a pcap file";
    longDescription = ''
      udpreplay is a lightweight alternative to tcpreplay for replaying UDP unicast and multicast streams from a pcap file.
    '';
    homepage = "https://github.com/rigtorp/udpreplay";
    license = licenses.mit;
    maintainers = [ maintainers.considerate ];
    platforms = platforms.linux;
  };
}
