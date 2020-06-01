{ stdenv, fetchurl
, getopt
}:

stdenv.mkDerivation rec {
  pname = "bmake";
  version = "20200506";

  src = fetchurl {
    url    = "http://www.crufty.net/ftp/pub/sjg/${pname}-${version}.tar.gz";
    sha256 = "1qiq6lvlg2hqiq03slv4vzv3bn4cr3w95r3i6m5fa4hgn2dkrhqa";
  };

  nativeBuildInputs = [ getopt ];

  patches = [
    ./bootstrap-fix.patch
    ./fix-unexport-env-test.patch
  ];

  meta = with stdenv.lib; {
    description = "Portable version of NetBSD 'make'";
    homepage    = "http://www.crufty.net/help/sjg/bmake.html";
    license     = licenses.bsd3;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
