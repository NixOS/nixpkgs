{ stdenv, fetchFromGitHub
, supportCompressedPackets ? true, zlib, bzip2
}:

stdenv.mkDerivation rec {
  name = "pgpdump-${version}";
  version = "0.33";

  src = fetchFromGitHub {
    owner = "kazu-yamamoto";
    repo = "pgpdump";
    rev = "v${version}";
    sha256 = "0pi9qdbmcmi58gmljin51ylbi3zkknl8fm26jm67cpl55hvfsn23";
  };

  buildInputs = stdenv.lib.optionals supportCompressedPackets [ zlib bzip2 ];

  meta = with stdenv.lib; {
    description = "A PGP packet visualizer";
    longDescription = ''
      pgpdump is a PGP packet visualizer which displays the packet format of
      OpenPGP (RFC 4880) and PGP version 2 (RFC 1991).
    '';
    homepage = http://www.mew.org/~kazu/proj/pgpdump/en/;
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ primeos ];
  };
}
