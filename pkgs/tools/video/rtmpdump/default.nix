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
  version = "2015-12-30";

  src = fetchgit {
    url = git://git.ffmpeg.org/rtmpdump;
    # Currently the latest commit is used (a release has not been made since 2011, i.e. '2.4')
    rev = "fa8646daeb19dfd12c181f7d19de708d623704c0";
    sha256 = "17m9rmnnqyyzsnnxcdl8258hjmw16nxbj1n1lr7fj3kmcs189iig";
  };

  makeFlags = [ ''prefix=$(out)'' ]
    ++ optional gnutlsSupport "CRYPTO=GNUTLS"
    ++ optional opensslSupport "CRYPTO=OPENSSL"
    ++ optional stdenv.isDarwin "SYS=darwin"
    ++ optional stdenv.cc.isClang "CC=clang";

  propagatedBuildInputs = [ zlib ]
    ++ optionals gnutlsSupport [ gnutls nettle ]
    ++ optional opensslSupport openssl;

  outputs = [ "out" "dev" ];

  meta = {
    description = "Toolkit for RTMP streams";
    homepage    = http://rtmpdump.mplayerhq.hu/;
    license     = licenses.gpl2;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ codyopel viric ];
  };
}
