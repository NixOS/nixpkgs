{ stdenv, lib, fetchurl,  }:

stdenv.mkDerivation rec {
  pname = "litmus";
  version = "0.13";

  src = fetchurl {
    url = "http://www.webdav.org/neon/litmus/litmus-${version}.tar.gz";
    hash = "sha256-CdYVlYEhcGRE22fgnEDfX3U8zx+hSEb960OSmKqaw/8=";
  };

  meta = with lib; {
    homepage = "http://www.webdav.org/neon/litmus/";
    description = "WebDAV server test suite";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ cafehaine ];
    platforms = platforms.unix;
  };
}
