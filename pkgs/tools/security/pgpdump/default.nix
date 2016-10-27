{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "pgpdump-${version}";
  version = "0.31";

  src = fetchFromGitHub {
    owner = "kazu-yamamoto";
    repo = "pgpdump";
    rev = "v${version}";
    sha256 = "05ywdgxzq3976dsy95vgdx3nnhd9i9vypzyrkabpmnxphfnjfrb4";
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

