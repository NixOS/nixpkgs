{ stdenv, fetchurl
, getopt
}:

stdenv.mkDerivation rec {
  pname = "bmake";
  version = "20200710";

  src = fetchurl {
    url    = "http://www.crufty.net/ftp/pub/sjg/${pname}-${version}.tar.gz";
    sha256 = "0v5paqdc0wnqlw4dy45mnydkmabsky33nvd7viwd2ygg351zqf35";
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
