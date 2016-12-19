{ stdenv, fetchgit, zlib
, gnutlsSupport ? false, gnutls ? null, nettle ? null
, opensslSupport ? true, openssl ? null
}:

# Must have an ssl library enabled
assert (gnutlsSupport || opensslSupport);
assert gnutlsSupport -> gnutlsSupport != null && nettle != null && !opensslSupport;
assert opensslSupport -> openssl != null && !gnutlsSupport;

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "rtmpdump-${version}";
  version = "2015-01-15";

  src = fetchgit {
    url = git://git.ffmpeg.org/rtmpdump;
    # Currently the latest commit is used (a release has not been made since 2011, i.e. '2.4')
    rev = "a107cef9b392616dff54fabfd37f985ee2190a6f";
    sha256 = "03x7dy111dk8b23cq2wb5h8ljcv58fzhp0xm0d1myfvzhr9amqqs";
  };

  makeFlags = [ ''prefix=$(out)'' ]
    ++ optional gnutlsSupport "CRYPTO=GNUTLS"
    ++ optional opensslSupport "CRYPTO=OPENSSL"
    ++ optional stdenv.isDarwin "SYS=darwin"
    ++ optional stdenv.cc.isClang "CC=clang";

  propagatedBuildInputs = [ zlib ]
    ++ optionals gnutlsSupport [ gnutls nettle ]
    ++ optional opensslSupport openssl;

  meta = {
    description = "Toolkit for RTMP streams";
    homepage    = http://rtmpdump.mplayerhq.hu/;
    license     = licenses.gpl2;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ codyopel viric ];
  };
}
