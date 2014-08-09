{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "cadaver-0.23.3";

  src = fetchurl {
    url = "http://www.webdav.org/cadaver/${name}.tar.gz";
    sha256 = "1jizq69ifrjbjvz5y79wh1ny94gsdby4gdxwjad4bfih6a5fck7x";
  };

  meta = with stdenv.lib; {
    description = "A command-line WebDAV client for Unix";
    homepage    = http://www.webdav.org/cadaver;
    maintainers = with maintainers; [ ianwookim ];
    license     = licenses.gpl2;
    platforms   = with platforms; linux ++ freebsd ++ openbsd;
  };
}
