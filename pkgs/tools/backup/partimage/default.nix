{stdenv
, fetchurl
, fetchpatch
, bzip2
, zlib
, newt
, openssl
, pkgconfig
, slang
, autoreconfHook
}:
stdenv.mkDerivation {
  name = "partimage-0.6.9";
  enableParallelBuilding = true;

  src = fetchurl {
    url = mirror://sourceforge/partimage/partimage-0.6.9.tar.bz2;
    sha256 = "0db6xiphk6xnlpbxraiy31c5xzj0ql6k4rfkmqzh665yyj0nqfkm";
  };

  configureFlags = [ "--with-ssl-headers=${openssl.dev}/include/openssl" ];

  nativeBuildInputs = [ pkgconfig autoreconfHook ];
  buildInputs = [ bzip2 zlib newt newt openssl slang ];

  patches = [
    ./gentoos-zlib.patch
    (fetchpatch {
      name = "openssl-1.1.patch";
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/sys-block/partimage/files/"
        + "partimage-0.6.9-openssl-1.1-compatibility.patch?id=3fe8e9910002b6523d995512a646b063565d0447";
      sha256 = "1hs0krxrncxq1w36bhad02yk8yx71zcfs35cw87c82sl2sfwasjg";
    })
  ];

  meta = {
    description = "Opensource disk backup software";
    homepage = http://www.partimage.org;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = stdenv.lib.platforms.linux;
  };
}
