{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "pgpdump-${version}";
  version = "0.32";

  src = fetchFromGitHub {
    owner = "kazu-yamamoto";
    repo = "pgpdump";
    rev = "v${version}";
    sha256 = "1ip7q5sgh3nwdqbrzpp6sllkls5kma98kns53yspw1830xi1n8xc";
  };

  meta = with stdenv.lib; {
    description = "A PGP packet visualizer";
    longDescription = ''
      pgpdump is a PGP packet visualizer which displays the packet format of
      OpenPGP (RFC 4880) and PGP version 2 (RFC 1991).
    '';
    homepage = "http://www.mew.org/~kazu/proj/pgpdump/en/";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos ];
  };
}

