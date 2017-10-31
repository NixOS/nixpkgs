{ stdenv, fetchurl, fetchpatch, openssl }:

stdenv.mkDerivation rec {
  name = "cadaver-0.23.3";

  src = fetchurl {
    url = "http://www.webdav.org/cadaver/${name}.tar.gz";
    sha256 = "1jizq69ifrjbjvz5y79wh1ny94gsdby4gdxwjad4bfih6a5fck7x";
  };

  patches = [
    (fetchpatch {
      url = https://projects.archlinux.org/svntogit/community.git/plain/trunk/disable-sslv2.patch?h=packages/cadaver;
      name = "disable-sslv2.patch";
      sha256 = "1qx65hv584wdarks51yhd3y38g54affkphm5wz27xiz4nhmbssrr";
    })
  ];

  configureFlags = "--with-ssl";

  buildInputs = [ openssl ];

  meta = with stdenv.lib; {
    description = "A command-line WebDAV client";
    homepage    = http://www.webdav.org/cadaver;
    maintainers = with maintainers; [ ianwookim ];
    license     = licenses.gpl2;
    platforms   = with platforms; linux ++ freebsd ++ openbsd;
  };
}
