{stdenv, fetchurl, fetchpatch, bzip2, zlib, newt, openssl, pkgconfig, slang
, automake, autoconf, libtool, gettext
}:
stdenv.mkDerivation {
  name = "partimage-0.6.9";
  enableParallelBuilding = true;

  src = fetchurl {
    url = mirror://sourceforge/partimage/partimage-0.6.9.tar.bz2;
    sha256 = "0db6xiphk6xnlpbxraiy31c5xzj0ql6k4rfkmqzh665yyj0nqfkm";
  };
  configureFlags = "--with-ssl-headers=${openssl.dev}/include/openssl";

  buildInputs = [bzip2 zlib newt newt openssl pkgconfig slang
    # automake autoconf libtool gettext
  ];

  patches = [
    ./gentoos-zlib.patch
    (fetchpatch {
      name = "no-SSLv2.patch";
      url = "https://projects.archlinux.org/svntogit/community.git/plain/trunk"
        + "/use-SSLv3-by-default.patch?h=packages/partimage&id=7e95d1c6614e";
      sha256 = "17dfqwvwnkinz8vs0l3bjjbmfx3a7y8nv3wn67gjsqpmggcpdnd6";
    })
  ];

  meta = {
    description = "opensource disk backup software";
    homepage = http://www.partimage.org;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = stdenv.lib.platforms.linux;
  };
}
