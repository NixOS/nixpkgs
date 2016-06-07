{ stdenv, fetchurl, cmake, openssl, libevent }:

stdenv.mkDerivation rec {
  name = "libevhtp-seafile-${version}";
  version = "1.2.9";

  src = fetchurl {
    url = "https://github.com/ellzey/libevhtp/archive/${version}.tar.gz";
    sha256 = "0z59qjrmz20ifb7ak03bvj2bxbpl038vd6301dgbw4ajmdfi4iba";
  };

  buildInputs = [ cmake openssl libevent ];

  cmakeFlags = "-DEVHTP_DISABLE_SSL=ON -DEVHTP_BUILD_SHARED=ON";

  preConfigure = ''
    cmakeFlags+=-DCMAKE_INSTALL_PREFIX=$out
  '';

  buildPhase = "cmake";

  meta = with stdenv.lib; {
    description = "A more flexible replacement for libevent's httpd API";
    homepage = "https://github.com/ellzey/libevhtp";
    license = licenses.bsd3;
    maintainers = with maintainers; [ hhhorn ];
    platforms = platforms.linux;
  };
}
