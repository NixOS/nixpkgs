{ lib, stdenv, fetchurl, fetchpatch, neon, pkg-config, readline, zlib, openssl }:

stdenv.mkDerivation rec {
  pname = "cadaver";
  version = "0.23.3";

  src = fetchurl {
    url = "http://www.webdav.org/cadaver/cadaver-${version}.tar.gz";
    sha256 = "1jizq69ifrjbjvz5y79wh1ny94gsdby4gdxwjad4bfih6a5fck7x";
  };

  patches = [
    (fetchpatch {
      url = "https://projects.archlinux.org/svntogit/community.git/plain/trunk/disable-sslv2.patch?h=packages/cadaver";
      name = "disable-sslv2.patch";
      sha256 = "1qx65hv584wdarks51yhd3y38g54affkphm5wz27xiz4nhmbssrr";
    })
    # Cadaver also works with newer versions of neon than stated
    # in the configure script
    ./configure.patch
  ];

  configureFlags = [ "--with-ssl" "--with-readline" ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ neon readline zlib openssl ];

  meta = with lib; {
    description = "A command-line WebDAV client";
    homepage    = "http://www.webdav.org/cadaver";
    maintainers = with maintainers; [ ianwookim ];
    license     = licenses.gpl2;
    platforms   = with platforms; linux ++ freebsd ++ openbsd;
  };
}
