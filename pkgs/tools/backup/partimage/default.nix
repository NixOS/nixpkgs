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
  configureFlags = "--with-ssl-headers=${openssl}/include/openssl";

  buildInputs = [bzip2 zlib newt newt openssl pkgconfig slang
    # automake autoconf libtool gettext
  ];

  patches = [
    ./gentoos-zlib.patch
    (fetchpatch {
      name = "no-SSLv2.patch";
      url = "https://projects.archlinux.org/svntogit/community.git/plain/trunk"
        + "/use-SSLv3-by-default.patch?h=packages/partimage&id=7e95d1c6614e";
      sha256 = "1zfixa6g1nb1hqfzn2wvyvxsr38gm7908zfml2iaqnwy6iz6jd8v";
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
