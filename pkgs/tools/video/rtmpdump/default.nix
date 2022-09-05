{ lib
, stdenv
, fetchgit
, fetchpatch
, zlib
, gnutlsSupport ? false
, gnutls
, nettle
, opensslSupport ? true
, openssl
}:

assert (gnutlsSupport || opensslSupport);

with lib;
stdenv.mkDerivation {
  pname = "rtmpdump";
  version = "unstable-2021-02-19";

  src = fetchgit {
    url = "git://git.ffmpeg.org/rtmpdump";
    # Currently the latest commit is used (a release has not been made since 2011, i.e. '2.4')
    rev = "f1b83c10d8beb43fcc70a6e88cf4325499f25857";
    sha256 = "0vchr0f0d5fi0zaa16jywva5db3x9dyws7clqaq32gwh5drbkvs0";
  };

  patches = [
    # Fix build with OpenSSL 1.1
    (fetchpatch {
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/media-video/rtmpdump/files/rtmpdump-openssl-1.1.patch?id=1e7bef484f96e7647f5f0911d3c8caa48131c33b";
      sha256 = "1wds98pk8qr7shkfl8k49iirxiwd972h18w84bamiqln29wv6ql1";
    })
  ];

  makeFlags = [
    "prefix=$(out)"
    "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
  ]
    ++ optional gnutlsSupport "CRYPTO=GNUTLS"
    ++ optional opensslSupport "CRYPTO=OPENSSL"
    ++ optional stdenv.isDarwin "SYS=darwin"
    ++ optional stdenv.cc.isClang "CC=clang";

  propagatedBuildInputs = [ zlib ]
    ++ optionals gnutlsSupport [ gnutls nettle ]
    ++ optional opensslSupport openssl;

  outputs = [ "out" "dev" ];

  separateDebugInfo = true;

  meta = {
    description = "Toolkit for RTMP streams";
    homepage = "https://rtmpdump.mplayerhq.hu/";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ codyopel ];
  };
}
