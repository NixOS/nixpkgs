{ stdenv, fetchurl
, getopt
}:

stdenv.mkDerivation rec {
  pname = "bmake";
  version = "20200212";

  src = fetchurl {
    url    = "http://www.crufty.net/ftp/pub/sjg/${pname}-${version}.tar.gz";
    sha256 = "134ibplk5rj7s3ig2czbhqs89l45jl6vswg3cy6xzm0anz5smhb2";
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
