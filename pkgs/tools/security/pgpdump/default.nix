{ lib, stdenv, fetchFromGitHub
, supportCompressedPackets ? true, zlib, bzip2
}:

stdenv.mkDerivation rec {
  pname = "pgpdump";
  version = "0.34";

  src = fetchFromGitHub {
    owner = "kazu-yamamoto";
    repo = "pgpdump";
    rev = "v${version}";
    sha256 = "1vvxhbz8nqzw9gf7cdmas2shzziznsqj84w6w74h8zzgb4m3byzz";
  };

  buildInputs = lib.optionals supportCompressedPackets [ zlib bzip2 ];

  meta = with lib; {
    description = "A PGP packet visualizer";
    longDescription = ''
      pgpdump is a PGP packet visualizer which displays the packet format of
      OpenPGP (RFC 4880) and PGP version 2 (RFC 1991).
    '';
    homepage = "http://www.mew.org/~kazu/proj/pgpdump/en/";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ primeos ];
  };
}
