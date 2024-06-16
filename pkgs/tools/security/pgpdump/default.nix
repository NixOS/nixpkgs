{ lib, stdenv, fetchFromGitHub
, supportCompressedPackets ? true, zlib, bzip2
}:

stdenv.mkDerivation rec {
  pname = "pgpdump";
  version = "0.36";

  src = fetchFromGitHub {
    owner = "kazu-yamamoto";
    repo = "pgpdump";
    rev = "v${version}";
    sha256 = "sha256-JKedgHCTDnvLyLR3nGl4XFAaxXDU1TgHrxPMlRFwtBo=";
  };

  buildInputs = lib.optionals supportCompressedPackets [ zlib bzip2 ];

  meta = with lib; {
    description = "A PGP packet visualizer";
    mainProgram = "pgpdump";
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
