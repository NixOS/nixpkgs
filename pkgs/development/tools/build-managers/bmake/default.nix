{ stdenv, fetchurl
, getopt
}:

stdenv.mkDerivation rec {
  pname = "bmake";
  version = "20200629";

  src = fetchurl {
    url    = "http://www.crufty.net/ftp/pub/sjg/${pname}-${version}.tar.gz";
    sha256 = "1cxmsz48ap6gpwx5qkkvvfsiqxc7zpn8gzmhvc1jsfha68195ms5";
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
